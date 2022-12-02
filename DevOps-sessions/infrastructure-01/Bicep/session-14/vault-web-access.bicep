param region string = 'westeurope'
param planName string = 'exampleplan'
param appName string
param planTier string = 'B1'
param nodesInWebFarm int = 1
param dockerHubImage string = 'nginx:alpine'

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

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: appName
  location: region
  properties: {
    accessPolicies: [
        {
            objectId: reference(resourceId('Microsoft.Web/sites', appName), '2021-03-01', 'Full').identity.principalId
            permissions: {
                secrets: [ 'get', 'list' ]
            }
            tenantId: subscription().tenantId
        }
    ]
    createMode: 'default'
    sku: {
        family: 'A'
        name: 'standard'
    }
    tenantId: subscription().tenantId
  }
  dependsOn: [appService]
} 
