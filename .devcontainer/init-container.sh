#!/bin/bash
# M365 Copilot Development Container Initialization Script

set -e  # Exit on any error

echo "🚀 Initializing M365 Copilot Development Environment..."

# Configure Azure CLI
echo "📝 Configuring Azure CLI..."
az config set extension.use_dynamic_install=yes_without_prompt --only-show-errors
az config set core.output=table --only-show-errors
az config set core.collect_telemetry=false --only-show-errors
az config set core.disable_check_version=true --only-show-errors

# Verify installations
echo "🔍 Verifying tool installations..."
echo "✅ Azure CLI version: $(az --version | head -n1)"
echo "✅ Azure Functions Core Tools version: $(func --version)"
echo "✅ Azurite version: $(azurite --version)"
echo "✅ Teams Toolkit CLI version: $(teamsapp --version)"
echo "✅ Node.js version: $(node --version)"
echo "✅ npm version: $(npm --version)"
echo "✅ .NET version: $(dotnet --version)"
echo "✅ Kiota version: $(kiota --version)"
echo "✅ GitHub CLI version: $(gh --version | head -n1)"

# Create common directories
echo "📁 Creating common project directories..."
mkdir -p /workspace/{src,tests,docs,scripts,demos,labs}

echo "🎉 M365 Copilot Development Environment ready!"
echo ""
echo "📖 Quick Start:"
echo "   • Azure CLI: az login"
echo "   • Teams Toolkit: teamsapp new"
echo "   • Kiota: kiota generate"
echo "   • GitHub CLI: gh auth login"
echo ""
echo "💡 Happy coding! 🚀"
