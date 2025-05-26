#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Setup and manage GitHub secrets for the Copilot Agents Development environment

.DESCRIPTION
    This script helps set up GitHub repository secrets required for various pipelines
    including the DevContainer build pipeline and any future Azure deployment pipelines.
    
.PARAMETER Action
    The action to perform: check, setup, list, or help

.PARAMETER Repository
    The GitHub repository in format owner/repo (e.g., user/m365-copilot)

.EXAMPLE
    .\setup-github-secrets.ps1 -Action check
    .\setup-github-secrets.ps1 -Action setup -Repository "your-org/m365-copilot"
    .\setup-github-secrets.ps1 -Action list -Repository "your-org/m365-copilot"
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("check", "setup", "list", "help")]
    [string]$Action = "check",
    
    [Parameter(Mandatory = $false)]
    [string]$Repository = "",
    
    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# Configuration
$RequiredSecrets = @{
    # DevContainer Pipeline Secrets (Current)
    "GITHUB_TOKEN" = @{
        Description = "GitHub Token for container registry access"
        Required = $false
        AutoProvided = $true
        Note = "Automatically provided by GitHub Actions"
    }
    
    # Future Azure Pipeline Secrets (Optional)
    "AZURE_CLIENT_ID" = @{
        Description = "Azure Service Principal Client ID"
        Required = $false
        AutoProvided = $false
        Note = "Required for Azure deployments"
    }
    "AZURE_CLIENT_SECRET" = @{
        Description = "Azure Service Principal Client Secret"
        Required = $false
        AutoProvided = $false
        Note = "Required for Azure deployments"
    }
    "AZURE_TENANT_ID" = @{
        Description = "Azure Tenant ID"
        Required = $false
        AutoProvided = $false
        Note = "Required for Azure deployments"
    }
    "AZURE_SUBSCRIPTION_ID" = @{
        Description = "Azure Subscription ID"
        Required = $false
        AutoProvided = $false
        Note = "Required for Azure deployments"
    }
}

# Colors for output
$Red = "`e[31m"
$Green = "`e[32m"
$Yellow = "`e[33m"
$Blue = "`e[34m"
$Magenta = "`e[35m"
$Cyan = "`e[36m"
$White = "`e[37m"
$Reset = "`e[0m"

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = $White
    )
    Write-Host "$Color$Message$Reset"
}

function Write-Header {
    param([string]$Title)
    Write-ColorOutput "`n═══════════════════════════════════════════════════════════════════" $Cyan
    Write-ColorOutput " $Title" $Cyan
    Write-ColorOutput "═══════════════════════════════════════════════════════════════════" $Cyan
}

function Write-Status {
    param(
        [string]$Message,
        [ValidateSet("Success", "Warning", "Error", "Info")]
        [string]$Status = "Info"
    )
    
    $StatusColor = switch ($Status) {
        "Success" { $Green }
        "Warning" { $Yellow }
        "Error" { $Red }
        "Info" { $Blue }
    }
    
    $Icon = switch ($Status) {
        "Success" { "✅" }
        "Warning" { "⚠️ " }
        "Error" { "❌" }
        "Info" { "ℹ️ " }
    }
    
    Write-ColorOutput "$Icon $Message" $StatusColor
}

function Test-GitHubCLI {
    try {
        $ghVersion = gh --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Status "GitHub CLI is installed: $($ghVersion.Split("`n")[0])" "Success"
            return $true
        }
    }
    catch {
        # Ignore error
    }
    
    Write-Status "GitHub CLI (gh) is not installed or not in PATH" "Error"
    Write-ColorOutput "Please install GitHub CLI from: https://cli.github.com/" $Yellow
    return $false
}

function Test-GitHubAuth {
    try {
        $authStatus = gh auth status 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Status "GitHub CLI is authenticated" "Success"
            return $true
        }
    }
    catch {
        # Ignore error
    }
    
    Write-Status "GitHub CLI is not authenticated" "Warning"
    Write-ColorOutput "Run 'gh auth login' to authenticate" $Yellow
    return $false
}

function Get-CurrentRepository {
    try {
        $remoteUrl = git remote get-url origin 2>$null
        if ($LASTEXITCODE -eq 0 -and $remoteUrl) {
            if ($remoteUrl -match "github\.com[:/]([^/]+/[^/]+?)(?:\.git)?/?$") {
                return $matches[1]
            }
        }
    }
    catch {
        # Ignore error
    }
    
    return $null
}

function Show-CurrentSecrets {
    param([string]$Repo)
    
    if (-not $Repo) {
        Write-Status "No repository specified" "Error"
        return
    }
    
    Write-Header "Current Repository Secrets"
    Write-ColorOutput "Repository: $Repo" $Blue
    
    try {
        $secrets = gh secret list --repo $Repo 2>$null
        if ($LASTEXITCODE -eq 0) {
            if ($secrets) {
                Write-ColorOutput "`nExisting secrets:" $Green
                $secrets | ForEach-Object {
                    Write-ColorOutput "  • $_" $White
                }
            } else {
                Write-Status "No secrets found in repository" "Info"
            }
        } else {
            Write-Status "Unable to list secrets (check permissions)" "Warning"
        }
    }
    catch {
        Write-Status "Error listing secrets: $($_.Exception.Message)" "Error"
    }
}

function Show-RequiredSecrets {
    Write-Header "Required Secrets for DevContainer Pipeline"
    
    foreach ($secretName in $RequiredSecrets.Keys) {
        $secret = $RequiredSecrets[$secretName]
        $statusIcon = if ($secret.AutoProvided) { "✅" } elseif ($secret.Required) { "❗" } else { "ℹ️ " }
        
        Write-ColorOutput "`n$statusIcon $secretName" $Cyan
        Write-ColorOutput "   Description: $($secret.Description)" $White
        Write-ColorOutput "   Required: $(if ($secret.Required) { 'Yes' } else { 'No' })" $White
        Write-ColorOutput "   Auto-provided: $(if ($secret.AutoProvided) { 'Yes' } else { 'No' })" $White
        Write-ColorOutput "   Note: $($secret.Note)" $Yellow
    }
}

function Invoke-CheckAction {
    Write-Header "GitHub Secrets Configuration Check"
    
    # Check GitHub CLI
    $hasGH = Test-GitHubCLI
    if (-not $hasGH) {
        return
    }
    
    # Check GitHub authentication
    $isAuthenticated = Test-GitHubAuth
    if (-not $isAuthenticated) {
        return
    }
    
    # Get repository
    $repo = if ($Repository) { $Repository } else { Get-CurrentRepository }
    if ($repo) {
        Write-Status "Detected repository: $repo" "Success"
        Show-CurrentSecrets -Repo $repo
    } else {
        Write-Status "Could not detect repository. Use -Repository parameter." "Warning"
    }
    
    Show-RequiredSecrets
    
    Write-Header "DevContainer Pipeline Status"
    Write-Status "The current DevContainer pipeline uses GITHUB_TOKEN which is automatically provided by GitHub Actions" "Success"
    Write-Status "No additional secrets are required for the DevContainer build pipeline" "Success"
    Write-ColorOutput "`nPipeline file: .github/workflows/build-devcontainer.yml" $Blue
    Write-ColorOutput "Image name: ms-copilots-agents-dev" $Blue
    Write-ColorOutput "Registry: ghcr.io (GitHub Container Registry)" $Blue
}

function Invoke-SetupAction {
    param([string]$Repo)
    
    if (-not $Repo) {
        Write-Status "Repository parameter is required for setup action" "Error"
        Write-ColorOutput "Usage: .\setup-github-secrets.ps1 -Action setup -Repository 'owner/repo'" $Yellow
        return
    }
    
    Write-Header "Setting up GitHub Secrets"
    Write-Status "Repository: $Repo" "Info"
    
    # Check prerequisites
    if (-not (Test-GitHubCLI)) { return }
    if (-not (Test-GitHubAuth)) { return }
    
    Write-Status "Current DevContainer pipeline requires no additional secrets" "Success"
    Write-ColorOutput "GITHUB_TOKEN is automatically provided by GitHub Actions" $Green
    
    Write-Header "Optional Azure Secrets Setup"
    Write-ColorOutput "If you plan to add Azure deployment pipelines, you may want to set up these secrets:" $Yellow
    
    $azureSecrets = $RequiredSecrets.Keys | Where-Object { $_ -like "AZURE_*" }
    foreach ($secretName in $azureSecrets) {
        Write-ColorOutput "`n• $secretName" $Cyan
        Write-ColorOutput "  $($RequiredSecrets[$secretName].Description)" $White
        
        if (-not $Force) {
            $response = Read-Host "Do you want to set $secretName now? (y/N)"
            if ($response -eq 'y' -or $response -eq 'Y') {
                $secretValue = Read-Host "Enter value for $secretName" -AsSecureString
                $plainValue = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secretValue))
                
                try {
                    gh secret set $secretName --body $plainValue --repo $Repo
                    Write-Status "Successfully set $secretName" "Success"
                }
                catch {
                    Write-Status "Failed to set $secretName: $($_.Exception.Message)" "Error"
                }
            }
        }
    }
}

function Invoke-ListAction {
    param([string]$Repo)
    
    if (-not $Repo) {
        $Repo = Get-CurrentRepository
    }
    
    if (-not $Repo) {
        Write-Status "Could not determine repository. Use -Repository parameter." "Error"
        return
    }
    
    Write-Header "GitHub Repository Secrets"
    Show-CurrentSecrets -Repo $Repo
}

function Show-Help {
    Write-Header "GitHub Secrets Setup Script Help"
    
    Write-ColorOutput @"
This script helps manage GitHub repository secrets for the Copilot Agents Development environment.

ACTIONS:
  check   - Check current secret configuration and requirements
  setup   - Interactive setup of repository secrets
  list    - List existing secrets in the repository
  help    - Show this help message

EXAMPLES:
  .\setup-github-secrets.ps1 -Action check
  .\setup-github-secrets.ps1 -Action setup -Repository "your-org/m365-copilot"
  .\setup-github-secrets.ps1 -Action list

CURRENT PIPELINE STATUS:
✅ DevContainer pipeline is ready to run
✅ No additional secrets required
✅ GITHUB_TOKEN is automatically provided

The DevContainer build pipeline (.github/workflows/build-devcontainer.yml) will:
• Build the ms-copilots-agents-dev container image
• Push to GitHub Container Registry (ghcr.io)
• Create tags: 1.0.0, latest, and branch-specific tags
"@ $White
}

# Main execution
switch ($Action) {
    "check" { Invoke-CheckAction }
    "setup" { Invoke-SetupAction -Repo $Repository }
    "list" { Invoke-ListAction -Repo $Repository }
    "help" { Show-Help }
    default { Show-Help }
}

Write-ColorOutput "`n" $Reset
