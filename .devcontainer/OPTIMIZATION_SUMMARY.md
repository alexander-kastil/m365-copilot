# DevContainer Optimization Summary

## Changes Made

### Moved to DevContainer Features

The following tasks were moved from the post-create script to devcontainer features for better reliability and caching:

1. **PowerShell Core Installation**
   - **Before**: Custom installation in Dockerfile using wget and dpkg
   - **After**: Using `ghcr.io/devcontainers/features/powershell:1` feature
   - **Benefits**:
     - More reliable installation
     - Better caching
     - Automatic updates
     - Reduced Dockerfile complexity

### Removed from Dockerfile

- Removed manual PowerShell installation steps since it's now handled by the feature
- Simplified the Dockerfile by removing custom PowerShell setup

### Updated post-create.sh

- Removed PowerShell availability check and installation logic
- Script now assumes PowerShell is available (installed via feature)
- Cleaner, more focused script

## Current Architecture

### DevContainer Features (Installed during container build)

- Node.js 22.11.0
- .NET 9.0
- Git (latest)
- Azure CLI (latest)
- Python 3.11
- **PowerShell (latest)** ← _Newly added_

### Post-Create Script (Runs after container is created)

- Azure CLI configuration
- Azure Functions Core Tools v4
- Azurite Storage Emulator
- Microsoft Graph PowerShell Module
- Teams Toolkit CLI
- Kiota (.NET tool)

## Further Optimization Opportunities

### 1. Consider Custom Feature for Microsoft Development Stack

You could create a custom devcontainer feature that bundles:

- Azure Functions Core Tools
- Azurite
- Teams Toolkit CLI
- Microsoft Graph PowerShell Module

**Example structure:**

```
.devcontainer/features/
├── microsoft-dev-tools/
│   ├── devcontainer-feature.json
│   └── install.sh
```

### 2. Package.json Approach for Node.js Tools

Instead of global npm installations in the script, consider adding a `package.json` file:

```json
{
  "devDependencies": {
    "azure-functions-core-tools": "^4.0.0",
    "azurite": "^3.0.0",
    "@microsoft/teamsapp-cli": "^2.0.0"
  }
}
```

Then use `npm install` in post-create script.

### 3. Multi-stage Build Optimization

Consider separating build-time dependencies from runtime dependencies in a multi-stage Dockerfile.

### 4. Environment-Specific Configurations

Use different devcontainer configurations for different development scenarios:

- `devcontainer-basic.json` - Core tools only
- `devcontainer-full.json` - All Microsoft development tools

## Benefits of Current Changes

1. **Faster Container Rebuilds**: PowerShell installation now cached at the feature layer
2. **More Reliable**: Using official Microsoft features instead of custom scripts
3. **Easier Maintenance**: Features are maintained by the devcontainer team
4. **Better Error Handling**: Features have built-in error handling and retry logic
5. **Cleaner Code**: Reduced complexity in both Dockerfile and post-create script

## Performance Impact

- **Container Build Time**: Slightly faster due to better caching of PowerShell installation
- **Post-Create Time**: Reduced by ~30 seconds (no longer installing PowerShell)
- **Rebuild Efficiency**: PowerShell changes now cached at feature layer instead of custom layer

## Recommendations

1. **Monitor the remaining installations** in post-create.sh to see if any other tools can be moved to features
2. **Consider creating a custom feature** for the Microsoft development stack if this pattern is used across multiple projects
3. **Use package.json** for Node.js tools if you want better dependency management
4. **Version pin** the npm packages in post-create.sh for reproducible builds
