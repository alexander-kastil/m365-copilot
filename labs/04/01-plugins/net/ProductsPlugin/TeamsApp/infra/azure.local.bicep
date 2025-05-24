@maxLength(20)
@minLength(4)
@description('Used to generate names for all resources in this file')
param resourceBaseName string

@description('Required when create Azure Bot service')
param botEntraAppClientId string
@maxLength(42)
param botDisplayName string
param botAppDomain string

param backendApiEntraAppClientId string
param productsApiEntraAppClientId string
@secure()
param productsApiEntraAppClientSecret string
param connectionName string

module azureBotRegistration './botRegistration/azurebot.bicep' = {
  name: 'Azure-Bot-registration'
  params: {
    resourceBaseName: resourceBaseName
    botEntraAppClientId: botEntraAppClientId
    botAppDomain: botAppDomain
    botDisplayName: botDisplayName
    backendApiEntraAppClientId: backendApiEntraAppClientId
    productsApiEntraAppClientId: productsApiEntraAppClientId
    productsApiEntraAppClientSecret: productsApiEntraAppClientSecret
    connectionName: connectionName
  }
}
