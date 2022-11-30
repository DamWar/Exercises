param region string = 'westeurope'
param vnetName string
param vnetAddressSpace string
param subnetName string
param subnets array

param serverName string
param dbName string
param dbTier string = 'S1'
param adminLogin string
@secure()
param adminPassword string
param dbBackupPolicy object
param firewallRules array

module vnet '../modules/vnet-subnet.bicep' = {
  name: 'add-vnet-subnets'
  params: {
    region: region
    vnetName: vnetName
    vnetAddressSpace: vnetAddressSpace
    subnets: subnets
  }
}

module database '../modules/sql-db.bicep' = {
  name: 'add-sql-db'
  params: {
    region: region
    serverName: serverName
    dbName: dbName
    dbTier: dbTier
    adminLogin: adminLogin
    adminPassword: adminPassword
    dbBackupPolicy: dbBackupPolicy
    firewallRules: firewallRules
  }
}

resource endpointSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: '${vnetName}/${subnetName}'
  properties: {
      addressPrefix: '10.0.2.0/24'
      serviceEndpoints: [
          {
              service: 'Microsoft.Sql'
              locations: [
                  region
              ]
          }
      ]
      privateEndpointNetworkPolicies: 'Disabled'
      privateLinkServiceNetworkPolicies: 'Disabled'
  }
  dependsOn: [vnet]
}

resource dbVnetRule 'Microsoft.Sql/servers/virtualNetworkRules@2022-02-01-preview' = {
  name: '${serverName}/Endpoints'
  properties: {
    virtualNetworkSubnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
    ignoreMissingVnetServiceEndpoint: true
  }
  dependsOn: [vnet, endpointSubnet, database]
}

