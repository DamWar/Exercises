param region string = 'westeurope'
param vnetName string
param vnetAddressSpace string
param subnets array

param planName string = 'exampleplan'
param appName string
param planTier string = 'B1'
param nodesInWebFarm int = 1
param dockerHubImage string = 'nginx:alpine'

param gatewayName string
param gatewaySubnetName string
param wafRules object

param privateEndpoints array

var privateDnsZoneName = 'damwar.dns-zone'


module appService '../modules/app-service.bicep' = {
  name: 'add-app'
  params: {
    region: region
    planName: planName
    appName: appName
    planTier: planTier
    nodesInWebFarm: nodesInWebFarm
    dockerHubImage: dockerHubImage
  }
}

module vnet '../modules/vnet-subnet.bicep' = {
  name: 'add-vnet-subnets'
  params: {
    region: region
    vnetName: vnetName
    vnetAddressSpace: vnetAddressSpace
    subnets: subnets
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-01-01' = {
  name: '${gatewayName}-ip'
  location: region
  sku: {
      name: 'Standard'
  }
  properties: {
      publicIPAllocationMethod: 'Static'
      publicIPAddressVersion: 'IPv4'
  }
}

resource appGateway 'Microsoft.Network/applicationGateways@2022-01-01' = {
  name: gatewayName
  location: region
  properties: {
    webApplicationFirewallConfiguration: wafRules
    sku: {
        capacity: 1
        name: 'WAF_v2'
        tier: 'WAF_v2'
    }
    backendAddressPools: [
        {
            name: 'back-pool'
            properties: {
                backendAddresses: [
                    {
                      fqdn: '${appName}.${privateDnsZoneName}'
                    }
                ]
            }
        }
    ]
    backendHttpSettingsCollection: [
        {
            name: 'back-http'
            properties: {
                hostName: '${appName}.azurewebsites.net'
                port: 80
                protocol: 'Http'
                requestTimeout: 30
            }
        }
    ]
    frontendIPConfigurations: [
        {   
            name: 'front-ip'
            properties: {
                privateIPAllocationMethod: 'Dynamic'
                publicIPAddress: {
                    id: publicIp.id
                }
            }
        }
    ]
    frontendPorts: [
        {
            name: 'front-ports'
            properties: {
                port: 80
            }
        }
    ]
    gatewayIPConfigurations: [
        {
            name: 'gateway-ip'
            properties: {
                subnet: {
                    id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, gatewaySubnetName)
                }
            }
        }
    ]
    httpListeners: [
      {
        name: 'http-listener'
        properties: {
          customErrorConfigurations: [
            {
              customErrorPageUrl: 'https://www.google.com/index.html'
              statusCode: 'HttpStatus403'
            }
          ]
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', gatewayName, 'front-ip')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationgateways/frontendPorts', gatewayName, 'front-ports')
          }
          protocol: 'http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'routing-rules'
        properties: {
          priority: 300
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationgateways/backendAddressPools', gatewayName, 'back-pool')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationgateways/backendHttpSettingsCollection', gatewayName, 'back-http')
          }
          httpListener: {
            id: resourceId('Microsoft.Network/applicationgateways/httpListeners', gatewayName, 'http-listener')
          }
          ruleType: 'basic'
        }
      }
    ]
  }
  dependsOn: [vnet]
}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = [for i in range(0, length(privateEndpoints)):{
  name: privateEndpoints[i].name
  location: region
  properties: {
    ipConfigurations: [
      {
        name: '${privateEndpoints[i].name}-pip'
        properties: {
          groupId: 'sites'
          memberName: 'sites'
          privateIPAddress: privateEndpoints[i].privateIpAddress
        }
      }
    ]
    subnet: {
      id: resourceId(privateEndpoints[i].subnet.type, privateEndpoints[i].subnet.vnetName, privateEndpoints[i].subnet.subnetName)
      applicationGatewayIpConfigurations: [
        {
          id: appGateway.properties.gatewayIPConfigurations
        }
      ]
    }
    privateLinkServiceConnections: [
      {
        name: privateEndpoints[i].privateLinkServiceConnections.name
        properties: {
          privateLinkServiceId: resourceId(privateEndpoints[i].privateLinkServiceConnections.properties.privateLinkServiceResource.type, privateEndpoints[i].privateLinkServiceConnections.properties.privateLinkServiceResource.name)
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
  dependsOn: [vnet]
}]

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: 'global'
  properties: {}
  dependsOn: [vnet]
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'vnet-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
  }
}

resource privateDnsZoneAlias 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZone
  name: appName
  properties: {
    ttl: 60
    aRecords: [for i in range(0, length(privateEndpoints)): {
        ipv4Address: privateEndpoints[i].privateIpAddress  
    }]
  }
}
