@maxLength(20)
@minLength(4)
@description('Used to generate names for all resources in this file')
param resourceBaseName string

@maxLength(42)
param botDisplayName string

param botServiceName string = resourceBaseName
param botServiceSku string = 'F0'
param botEntraAppClientId string
param botAppDomain string

param backendApiEntraAppClientId string
param productsApiEntraAppClientId string
@secure()
param productsApiEntraAppClientSecret string
param connectionName string

// Register your web service as a bot with the Bot Framework
resource botService 'Microsoft.BotService/botServices@2021-03-01' = {
  kind: 'azurebot'
  location: 'global'
  name: botServiceName
  properties: {
    displayName: botDisplayName
    endpoint: 'https://${botAppDomain}/api/messages'
    msaAppId: botEntraAppClientId
  }
  sku: {
    name: botServiceSku
  }
}

// Connect the bot service to Microsoft Teams
resource botServiceMsTeamsChannel 'Microsoft.BotService/botServices/channels@2021-03-01' = {
  parent: botService
  location: 'global'
  name: 'MsTeamsChannel'
  properties: {
    channelName: 'MsTeamsChannel'
  }
}

// Connect the bot service to Outlook, and other Microsoft 365 applications
resource botServiceM365ExtensionsChannel 'Microsoft.BotService/botServices/channels@2022-06-15-preview' = {
  parent: botService
  location: 'global'
  name: 'M365Extensions'
  properties: {
    channelName: 'M365Extensions'
  }
}

resource botServicesProductsApiConnection 'Microsoft.BotService/botServices/connections@2022-09-15' = {
  parent: botService
  name: connectionName
  location: 'global'
  properties: {
    serviceProviderDisplayName: 'Azure Active Directory v2'
    serviceProviderId: '30dd229c-58e3-4a48-bdfd-91ec48eb906c'
    clientId: productsApiEntraAppClientId
    clientSecret: productsApiEntraAppClientSecret
    scopes: 'api://${backendApiEntraAppClientId}/Product.Read'
    parameters: [
      {
        key: 'tenantID'
        value: 'common'
      }
      {
        key: 'tokenExchangeUrl'
        value: 'api://${botAppDomain}/botid-${botEntraAppClientId}'
      }
    ]
  }
}
