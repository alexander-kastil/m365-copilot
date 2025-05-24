# M365 Copilot Development Container Builder Script (PowerShell)
# This script helps build, update, and export the development container

param(
    [Parameter(Position=0)]
    [ValidateSet("build", "rebuild", "test", "export", "push", "clean", "info", "help")]
    [string]$Command = "help",
    
    [Parameter(Position=1)]
    [string]$Tag = "latest"
)

# Configuration
$ImageName = "m365-copilot-dev"
$DefaultTag = "latest"
$BuilderTag = "builder"
$Dockerfile = "Dockerfile.standalone"

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Function to show usage
function Show-Usage {
    Write-Host "M365 Copilot Development Container Builder" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Usage: .\container-builder.ps1 [COMMAND] [TAG]"
    Write-Host ""
    Write-Host "Commands:"
    Write-Host "  build [TAG]     Build the container image (default: latest)"
    Write-Host "  rebuild [TAG]   Rebuild the container image without cache"
    Write-Host "  test [TAG]      Test the container image"
    Write-Host "  export [TAG]    Export the container image to tar file"
    Write-Host "  push [TAG]      Push the container image to registry"
    Write-Host "  clean           Clean up unused Docker resources"
    Write-Host "  info            Show container information"
    Write-Host "  help            Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\container-builder.ps1 build                    # Build with 'latest' tag"
    Write-Host "  .\container-builder.ps1 build v1.2.0            # Build with specific tag"
    Write-Host "  .\container-builder.ps1 rebuild                  # Rebuild without cache"
    Write-Host "  .\container-builder.ps1 export v1.2.0           # Export tagged image"
    Write-Host "  .\container-builder.ps1 test                     # Test the latest image"
    Write-Host ""
}

# Function to build the container
function Build-Container {
    param([string]$ImageTag = $DefaultTag)
    
    $FullImageName = "$ImageName`:$ImageTag"
    $CreatedDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    
    Write-Status "Building container: $FullImageName"
    Write-Status "Using Dockerfile: $Dockerfile"
    
    try {
        docker build `
            -f ".devcontainer/$Dockerfile" `
            -t $FullImageName `
            --label "org.opencontainers.image.created=$CreatedDate" `
            --label "org.opencontainers.image.version=$ImageTag" `
            .
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Container built successfully: $FullImageName"
        } else {
            Write-Error "Container build failed"
            exit 1
        }
    }
    catch {
        Write-Error "Error building container: $($_.Exception.Message)"
        exit 1
    }
}

# Function to rebuild the container without cache
function Rebuild-Container {
    param([string]$ImageTag = $DefaultTag)
    
    $FullImageName = "$ImageName`:$ImageTag"
    $CreatedDate = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    
    Write-Status "Rebuilding container (no cache): $FullImageName"
    
    try {
        docker build `
            --no-cache `
            -f ".devcontainer/$Dockerfile" `
            -t $FullImageName `
            --label "org.opencontainers.image.created=$CreatedDate" `
            --label "org.opencontainers.image.version=$ImageTag" `
            .
        
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Container rebuilt successfully: $FullImageName"
        } else {
            Write-Error "Container rebuild failed"
            exit 1
        }
    }
    catch {
        Write-Error "Error rebuilding container: $($_.Exception.Message)"
        exit 1
    }
}

# Function to test the container
function Test-Container {
    param([string]$ImageTag = $DefaultTag)
    
    $FullImageName = "$ImageName`:$ImageTag"
    
    Write-Status "Testing container: $FullImageName"
    
    # Test if image exists
    $ImageExists = docker image inspect $FullImageName 2>$null
    if (-not $ImageExists) {
        Write-Error "Container image $FullImageName not found. Build it first."
        exit 1
    }
    
    # Run initialization script
    Write-Status "Running initialization script..."
    docker run --rm $FullImageName /usr/local/bin/init-container.sh
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Initialization script failed"
        exit 1
    }
    
    # Test basic tools
    Write-Status "Testing development tools..."
    $TestScript = @"
echo '=== Tool Versions ==='
echo 'Node.js:' `$(node --version)
echo '.NET:' `$(dotnet --version)
echo 'Azure CLI:' `$(az --version | head -n1)
echo 'GitHub CLI:' `$(gh --version | head -n1)
echo 'Git:' `$(git --version)
echo 'Kiota:' `$(kiota --version)
echo 'Teams Toolkit:' `$(teamsapp --version)
echo 'Azure Functions:' `$(func --version)
"@
    
    docker run --rm $FullImageName bash -c $TestScript
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Container tests passed!"
    } else {
        Write-Error "Container tests failed"
        exit 1
    }
}

# Function to export the container
function Export-Container {
    param([string]$ImageTag = $DefaultTag)
    
    $FullImageName = "$ImageName`:$ImageTag"
    $ExportFile = "$ImageName-$ImageTag.tar"
    
    Write-Status "Exporting container: $FullImageName"
    
    # Test if image exists
    $ImageExists = docker image inspect $FullImageName 2>$null
    if (-not $ImageExists) {
        Write-Error "Container image $FullImageName not found. Build it first."
        exit 1
    }
    
    try {
        docker save $FullImageName -o $ExportFile
        
        if ($LASTEXITCODE -eq 0) {
            $FileSize = (Get-Item $ExportFile).Length / 1MB
            Write-Success "Container exported to: $ExportFile"
            Write-Status "File size: $([math]::Round($FileSize, 2)) MB"
        } else {
            Write-Error "Container export failed"
            exit 1
        }
    }
    catch {
        Write-Error "Error exporting container: $($_.Exception.Message)"
        exit 1
    }
}

# Function to push the container
function Push-Container {
    param([string]$ImageTag = $DefaultTag)
    
    $FullImageName = "$ImageName`:$ImageTag"
    
    Write-Warning "Push functionality requires configuring a container registry."
    Write-Status "To push to a registry, tag your image with the registry URL:"
    Write-Status "Example: docker tag $FullImageName youregistry.azurecr.io/$FullImageName"
    Write-Status "Then: docker push youregistry.azurecr.io/$FullImageName"
}

# Function to clean up Docker resources
function Clean-Docker {
    Write-Status "Cleaning up Docker resources..."
    
    try {
        # Remove dangling images
        $DanglingImages = docker images -f "dangling=true" -q
        if ($DanglingImages) {
            Write-Status "Removing dangling images..."
            docker rmi $DanglingImages
        }
        
        # Remove unused volumes
        Write-Status "Removing unused volumes..."
        docker volume prune -f
        
        # Remove unused networks
        Write-Status "Removing unused networks..."
        docker network prune -f
        
        Write-Success "Docker cleanup completed!"
    }
    catch {
        Write-Error "Error during cleanup: $($_.Exception.Message)"
    }
}

# Function to show container information
function Show-Info {
    Write-Status "M365 Copilot Development Container Information"
    Write-Host ""
    
    # Show available images
    Write-Status "Available Images:"
    docker images --filter=reference="$ImageName`:*" --format "table {{.Repository}}:{{.Tag}}`t{{.Size}}`t{{.CreatedAt}}"
    
    Write-Host ""
    Write-Status "Container Configuration:"
    Write-Host "  Image Name: $ImageName"
    Write-Host "  Dockerfile: $Dockerfile"
    Write-Host "  Default Tag: $DefaultTag"
    Write-Host "  Builder Tag: $BuilderTag"
    
    Write-Host ""
    Write-Status "Quick Commands:"
    Write-Host "  Build:   .\container-builder.ps1 build"
    Write-Host "  Test:    .\container-builder.ps1 test"
    Write-Host "  Export:  .\container-builder.ps1 export"
    Write-Host "  Clean:   .\container-builder.ps1 clean"
}

# Main script logic
switch ($Command.ToLower()) {
    "build" {
        Build-Container -ImageTag $Tag
    }
    "rebuild" {
        Rebuild-Container -ImageTag $Tag
    }
    "test" {
        Test-Container -ImageTag $Tag
    }
    "export" {
        Export-Container -ImageTag $Tag
    }
    "push" {
        Push-Container -ImageTag $Tag
    }
    "clean" {
        Clean-Docker
    }
    "info" {
        Show-Info
    }
    "help" {
        Show-Usage
    }
    default {
        Write-Error "Unknown command: $Command"
        Write-Host ""
        Show-Usage
        exit 1
    }
}
