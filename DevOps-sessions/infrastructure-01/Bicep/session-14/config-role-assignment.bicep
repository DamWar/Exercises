param region string = 'westeurope'
param planName string = 'exampleplan'
param appName string
param planTier string = 'B1'
param nodesInWebFarm int = 1
param dockerHubImage string = 'nginx:alpine'

param configName string

var linuxFxVersion = 'DOCKER|${dockerHubImage}'


resource serverFarm 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: planName
  location: region
  sku: {
    name: planTier
    size: planTier
    capacity: nodesInWebFarm
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    reserved: true
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource appService 'Microsoft.Web/sites@2021-03-01' = {
  name: appName
  location: region
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
      serverFarmId: serverFarm.id
      siteConfig: {
          linuxFxVersion: linuxFxVersion
      }
  }
} 

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: configName
  location: region
  sku: {
    name: 'standard'
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id)
  scope: appConfig
  properties: {
      roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/516239f1-63e1-4d78-a4de-a74fb236a071'
      principalId: appService.identity.principalId
  }
}
