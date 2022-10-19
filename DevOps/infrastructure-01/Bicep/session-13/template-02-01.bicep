param region string = 'westeurope'
param vnetName string
param vnetAddressSpace string
param subnets array

param planName string = 'exampleplan'
param appName string
param subnetName string
param planTier string = 'B1'
param nodesInWebFarm int = 1
param dockerHubImage string = 'nginx:alpine'

var linuxFxVersion = 'DOCKER|${dockerHubImage}'

module vnet '../modules/vnet-subnet.bicep' = {
  name: 'add-vnet-subnets'
  params: {
    region: region
    vnetName: vnetName
    vnetAddressSpace: vnetAddressSpace
    subnets: subnets
  }
}

resource serverFarm 'Microsoft.Web/serverFarms@2022-03-01' = {
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

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appName
  location: region
  kind: 'app'
  properties: {
      serverFarmId: serverFarm.id
      siteConfig: {
          linuxFxVersion: linuxFxVersion
      }
      virtualNetworkSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
  }
  dependsOn: [vnet]
} 

// resource vnetIntegration 'Microsoft.Web/sites/networkconfig@2021-02-01' = {
//   parent: appService
//   name: 'virtualNetwork'
//   properties: {
//       subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
//       swiftSupported: true
//   }
//   dependsOn: [vnet]
// }
