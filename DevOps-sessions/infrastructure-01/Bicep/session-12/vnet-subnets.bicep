param region string = 'westeurope'
param vnetName string
param vnetAddressSpace string
param subnets array

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' = {
  name: vnetName
  location: region
  properties: {
    addressSpace: {
        addressPrefixes: [
            vnetAddressSpace
        ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' = [for sub in subnets: {
  parent: vnet
  name: sub.name
  properties: sub.properties
}]
