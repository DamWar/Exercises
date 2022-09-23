param region string = 'westeurope'
param storageName string
param storageTier string = 'Standard_LRS'


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = {
  name: storageName
  location: region
  sku: {
      name: storageTier
  }
  kind: 'StorageV2'
  properties: {
      supportsHttpsTrafficOnly: true
  }
}
