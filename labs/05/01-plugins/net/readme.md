Install the .NET Template for Messaging Extension

```bash
dotnet new install M365Advocacy.Teams.Templates
```

Create the project

```bash
dotnet new teams-msgext-search --name "ProductsPlugin" --internal-name "msgext-products" --display-name "Contoso products" --short-description "Product look up tool." --full-description "Get real-time product information and share them in a conversation." --command-id "Search" --command-description "Find products by name" --command-title "Products" --parameter-name "ProductName" --parameter-title "Product name" --parameter-description "The name of the product as a keyword" --allow-scripts Yes  
```