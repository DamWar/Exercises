param region string = 'westeurope'
param storageName string
param storageTier string = 'Standard_LRS'

var accountSasProperties = {
  canonicalizedResource: '/blob/${storageName}/container'
  signedServices: 'b'
  signedPermission: 'rwl'
  signedExpiry: '2022-10-20T11:00:00Z'
  signedResourceTypes: 's'
}

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

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: '${storageAccount.name}/default/container'
}

output connection string = 'https://${storageName}.blob.${environment().suffixes.storage}/container?${storageAccount.listServiceSas('2021-04-01', accountSasProperties).serviceSasToken}&sr='
