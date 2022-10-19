param region string = 'westeurope'
param nsgName string
param rules array

resource nsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: nsgName
  location: region
  properties: {
    flushConnection: false
  }
}

resource securityRules 'Microsoft.Network/networkSecurityGroups/securityRules@2022-01-01' = [for rule in rules: {
  parent: nsg
  name: rule.name
  properties: rule.properties
}]

output nsgId string = nsg.id
