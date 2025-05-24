echo "Post-creation setup starting..."

# Install Azure CLI Extensions without prompt
echo "Configuring Azure CLI..."
az config set extension.use_dynamic_install=yes_without_prompt

# Install Azure Functions Core Tools v4
echo "Installing Azure Functions Core Tools..."
npm install -g azure-functions-core-tools@4 --unsafe-perm true --force

# Install Azurite Storage Emulator
echo "Installing Azurite Storage Emulator..."
npm install -g azurite

# Install Microsoft Graph PowerShell Module
echo "Installing Microsoft Graph PowerShell Module..."
pwsh -c "Install-Module Microsoft.Graph -Scope CurrentUser -Force"

# Install Teams Toolkit CLI
echo "Installing Teams Toolkit CLI..."
npm install -g @microsoft/teamsapp-cli

# Install Kiota
echo "Installing Kiota..."
dotnet tool install --global Microsoft.OpenApi.Kiota

echo "Post-creation setup completed!"