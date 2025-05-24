# Copilot Agents Development Environment

This repository provides **two distinct development container configurations** for Microsoft 365 Copilot Agents development, each optimized for different use cases.

## 🎯 Configuration Overview

### Default Configuration (`devcontainer.json`)

- **Purpose**: Fast startup for daily development
- **Base**: Custom Docker image with pre-installed tools
- **Startup Time**: ~30-60 seconds
- **Best For**: Regular development, quick prototyping, established workflows

### Builder Configuration (`devcontainer.builder.json`)

- **Purpose**: Dynamic tool management and container development
- **Base**: Microsoft .NET 9.0 base image + Dev Container Features
- **Startup Time**: ~5-10 minutes (first time)
- **Best For**: Adding new tools, updating dependencies, creating custom images

## 🚀 Quick Start

### Using Default Configuration (Recommended for Development)

1. Open this project in VS Code
2. When prompted, select **"Reopen in Container"**
3. VS Code will automatically use `devcontainer.json` (default configuration)
4. Start developing immediately! ⚡

### Using Builder Configuration

1. Open VS Code Command Palette: **Ctrl+Shift+P** (Windows/Linux) or **Cmd+Shift+P** (macOS)
2. Type: **"Dev Containers: Reopen in Container..."**
3. Select **"devcontainer.builder.json"** from the configuration list
4. VS Code will rebuild using the builder configuration with latest tools
5. First build may take 5-10 minutes for tool installation

### Switching Back to Default

1. Open Command Palette: **Ctrl+Shift+P**
2. Type: **"Dev Containers: Reopen in Container..."**
3. Select **"devcontainer.json"** (default configuration)
4. Enjoy fast startup times! 🚀

## 🛠️ Container Management Scripts

Use the provided scripts for advanced container operations:

### PowerShell (Windows)

```powershell
# Build and test a new container image
.\container-builder.ps1 build

# Export the current container to a new image version
.\container-builder.ps1 export -Tag "m365-copilot-dev:v2.0"

# Get detailed container and tool information
.\container-builder.ps1 info

# Clean up unused containers and images
.\container-builder.ps1 clean
```

### Bash (Linux/macOS/WSL)

```bash
# Build and test a new container image
./container-builder.sh build

# Export the current container to a new image version
./container-builder.sh export --tag "m365-copilot-dev:v2.0"

# Get detailed container and tool information
./container-builder.sh info

# Clean up unused containers and images
./container-builder.sh clean
```

> **Note**: These scripts are for advanced container management. For daily development, simply use VS Code's "Reopen in Container" feature.

## 📦 What's Included

### Development Tools

- **.NET 9.0** - Latest .NET runtime and SDK with global tools
- **Node.js 22.11.0** - JavaScript runtime with npm and development packages
- **Azure CLI** - Command-line tools for Azure with Bicep and DevOps extensions
- **Azure Functions Core Tools v4** - Local development for Azure Functions
- **Teams Toolkit CLI** - Microsoft Teams application development
- **GitHub CLI** - GitHub command-line interface with authentication
- **Kiota** - API client generator for Microsoft Graph
- **PowerShell Core** - Cross-platform PowerShell
- **Docker-in-Docker** - Container development capabilities
- **Kubectl & Helm** - Kubernetes development tools
- **Python 3.11** - Python runtime with development tools

### VS Code Extensions

#### Microsoft 365 & Teams Development

- Teams Toolkit Extension
- Adaptive Cards Extension
- Copilot Studio Extension
- AI Foundry Extension
- Microsoft Graph Kiota
- Semantic Kernel Extension

#### .NET Development

- C# DevKit and IntelliCode
- ASP.NET Core Snippet Pack
- NuGet Package Manager GUI

#### Azure Development

- Azure CLI Extension
- Azure Functions Extension
- Bicep Language Support

#### General Development

- GitHub Copilot & Copilot Chat
- GitLens Git Supercharged
- Prettier Code Formatter
- REST Client
- SQLite Viewer
- YAML Language Support

### Pre-configured Settings

- **Editor**: Format on save, organize imports, TypeScript/C# formatting
- **GitHub Copilot**: Enhanced with custom instructions for TypeScript and .NET
- **Development**: Optimized for M365, Teams, and Copilot development
- **Terminal**: Configured environment variables for optimal development

## 📋 Available Commands

Once the container is running, you have access to:

```bash
# Azure CLI
az login
az account list
az group list

# Teams Toolkit
teamsapp new
teamsapp provision
teamsapp deploy

# .NET Development
dotnet new list
dotnet run
dotnet test
kiota generate

# Node.js Development
npm init
npm install
npm run dev

# Azure Functions
func init
func new
func start

# GitHub CLI
gh auth login
gh repo create
gh pr create

# Container Management
docker build
docker run
docker ps
```

## 🔧 Configuration Details

### Default Configuration Features

- **Fast Startup**: Pre-built Docker image with all tools installed
- **Optimized Caching**: Minimal layer changes for faster rebuilds
- **Production Ready**: Stable tool versions for consistent development

### Builder Configuration Features

- **Dynamic Installation**: Uses Dev Container Features for flexible tool management
- **Latest Versions**: Always pulls latest tool versions during build
- **Customizable**: Easy to add/remove tools via feature configuration
- **Development Focus**: Includes additional development and debugging tools

### Port Configuration

The following ports are automatically forwarded:

- **3000**: Frontend Development Server (React, Vue, etc.)
- **4200**: Angular Development Server
- **5000**: .NET API (HTTP)
- **5001**: .NET API (HTTPS)
- **8080**: General Web Server

### Environment Variables

Pre-configured environment variables include:

- `NODE_ENV=development`
- `TZ=UTC`
- `DOTNET_CLI_TELEMETRY_OPTOUT=1`
- `DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1`

## 🎯 Switching Between Configurations

VS Code Dev Containers extension makes it easy to switch between configurations:

### Using Command Palette (Recommended)

1. **Open Command Palette**: `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
2. **Type**: `Dev Containers: Reopen in Container...`
3. **Select Configuration**:
   - `devcontainer.json` - Default (Fast startup)
   - `devcontainer.builder.json` - Builder (Dynamic tools)
4. **Wait for container to rebuild** and start developing!

### Using Configuration Picker

When reopening the project in VS Code:

1. **Click** the "Reopen in Container" notification
2. **Click** "Show All Definitions..." if multiple configs are detected
3. **Choose** your preferred configuration from the list
4. VS Code handles the rest automatically! ✨

### Configuration Details

- **No manual file renaming needed** - VS Code manages configurations
- **Automatic detection** - VS Code finds all `.json` files in `.devcontainer/`
- **Smart caching** - Faster subsequent rebuilds with same configuration
- **Easy switching** - Change configurations anytime via Command Palette

## 🔧 Customization

### Adding VS Code Extensions

Update the `extensions` array in your chosen configuration:

```json
{
  "customizations": {
    "vscode": {
      "extensions": [
        "ms-dotnettools.csharp",
        "your-new-extension-id"
      ]
    }
  }
}
```

### Adding Development Tools

#### For Default Configuration

Edit `Dockerfile.standalone` and rebuild:

```dockerfile
# Add your custom tools
RUN apt-get update && apt-get install -y your-tool
```

#### For Builder Configuration

Add features to `devcontainer.builder.json`:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/your-feature:1": {
      "version": "latest"
    }
  }
}
```

### Custom Environment Variables

```json
{
  "containerEnv": {
    "MY_API_URL": "https://api.example.com",
    "DEBUG_MODE": "true"
  }
}
```

## 📚 Documentation & Resources

- [Dev Containers Documentation](https://containers.dev/)
- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Microsoft 365 Development](https://docs.microsoft.com/en-us/microsoft-365/developer/)
- [Teams Toolkit Documentation](https://docs.microsoft.com/en-us/microsoftteams/platform/toolkit/visual-studio-code-overview)
- [Azure Functions Documentation](https://docs.microsoft.com/en-us/azure/azure-functions/)

## 🐛 Troubleshooting

### Container Won't Start

1. **Check Docker is running** - Ensure Docker Desktop is started
2. **Rebuild container**: **Ctrl+Shift+P** → "Dev Containers: Rebuild Container"
3. **Check the Output panel** - Look for error messages in VS Code Output
4. **Try different configuration** - Switch between default and builder configs

### Wrong Configuration Selected

1. **Open Command Palette**: **Ctrl+Shift+P**
2. **Type**: "Dev Containers: Reopen in Container..."
3. **Select correct configuration** from the list
4. **Wait for rebuild** to complete

### Tool Not Found

1. **Verify tool in configuration** - Check if tool is listed in your chosen config
2. **Check initialization scripts** - Look for errors in terminal output
3. **Try builder configuration** - Use `devcontainer.builder.json` for latest tools
4. **Restart container** if needed

### Performance Issues

1. **Use Default configuration** - Pre-built image is faster than builder config
2. **Close unnecessary VS Code extensions** - Reduce resource usage
3. **Allocate more resources** to Docker Desktop
4. **Clear Docker cache**: `docker system prune -a` (in host terminal)

### Multiple Configurations Not Showing

1. **Ensure files named correctly**: `devcontainer.json` and `devcontainer.builder.json`
2. **Files in correct location**: `.devcontainer/` folder
3. **Valid JSON syntax** - Check for syntax errors in configuration files
4. **Reload VS Code window**: **Ctrl+Shift+P** → "Developer: Reload Window"

### Azure CLI Authentication

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "your-subscription-id"

# Verify authentication
az account show
```

## 📝 Contributing

To contribute improvements to this development environment:

1. Fork this repository
2. Make changes to the appropriate configuration
3. Test both configurations work correctly
4. Submit a pull request with detailed description

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](../LICENSE) file for details.
