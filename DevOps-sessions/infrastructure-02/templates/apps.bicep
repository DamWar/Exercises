param region string = 'westeurope'
param planName string = 'exampleplan'
param appName array
param planTier string = 'B1'
param nodesInWebFarm int = 1
param dockerHubImage array


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

resource appService 'Microsoft.Web/sites@2021-03-01' = [for i in range(0, length(appName)):{
  name: appName[i]
  location: region
  kind: 'app'
  properties: {
      serverFarmId: serverFarm.id
      siteConfig: {
          linuxFxVersion: 'DOCKER|${dockerHubImage[i]}'
      }
  }
}]
