param region string = 'westeurope'
param vaultName string
param accessPolicies array

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: vaultName
  location: region
  properties: {
    accessPolicies: accessPolicies
    createMode: 'default'
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
  }
}
