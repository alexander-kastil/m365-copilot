### Copilot & Teams Developer Essentials

- Teams Developer Portal, Toolkit & DevTunnel
- Deploy Azure Resources with Bicep
- App Registrations & Single Sign-On (SSO)
- Microsoft Bot Framework
- Introduction to Adaptive Cards

## Links & Resources

[Teams Admin Center - https://admin.teams.microsoft.com/](https://admin.teams.microsoft.com/)

[Microsoft 365 Teams Developer Portal - https://dev.teams.microsoft.com/](https://dev.teams.microsoft.com/)

## Demos

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