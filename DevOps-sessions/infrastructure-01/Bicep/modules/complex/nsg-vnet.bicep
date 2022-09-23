param region string = 'westeurope'
param nsgName string
param rules array
param vnetName string
param vnetAddressSpace string
param subnets array


module nsg '../nsg.bicep' = {
  name: 'add-nsg'
  params: {
    region: region
    nsgName: nsgName
    rules: rules
  }
}

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
  properties: {
    addressPrefix: sub.properties.addressPrefix
    networkSecurityGroup: {
      id: nsg.outputs.nsgId
    }
  }
}]


