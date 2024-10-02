# Teams Resources

[Teams Admin Center](https://admin.teams.microsoft.com/)

[Teams Developer Portal](https://dev.teams.microsoft.com/)

[App Side-loading -Allow users to upload custom apps](https://learn.microsoft.com/en-us/microsoftteams/teams-custom-app-policies-and-settings#allow-users-to-upload-custom-apps)

## Extensions

[Teams Toolkit](https://marketplace.visualstudio.com/items?itemName=TeamsDevApp.ms-teams-vscode-extension)

[Adaptive Card Previewer](https://marketplace.visualstudio.com/items?itemName=TeamsDevApp.vscode-adaptive-cards)

## Deploy Hello-World MsgExtensionPlugin

A very simple Message Extension Plugin that can be used to explain the basic concepts of the Copilot and Teams Developer Tooling of this module.

Make sure [Microsoft 365 Developer Advocacy Templates](https://github.com/microsoft/m365advocacy-templates) are installed in Visual Studio

```bash
dotnet new install M365Advocacy.GraphConnectors.Templates
dotnet new install M365Advocacy.Teams.Templates
```

Create a HelloWorld MsgExtensionPlugin. It will be used to explain the basic concepts of the Copilot and Teams Developer Tooling of this module.

```bash
dotnet new teams-msgext-search --name "MsgExtensionPlugin" `
  --internal-name "msgext-intro-plugin" `
  --display-name "MsgExtIntro Plugin" `
  --short-description "Product look up tool." `
  --full-description "Get real-time product information and share them in a conversation." `
  --command-id "Search" `
  --command-description "Find products by name" `
  --command-title "Products" `
  --parameter-name "ProductName" `
  --parameter-title "Product name" `
  --parameter-description "The name of the product as a keyword" `
  --allow-scripts Yes
```    