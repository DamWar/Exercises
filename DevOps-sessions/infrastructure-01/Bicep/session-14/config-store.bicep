param region string = 'westeurope'
param configName string

resource appConfig 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: configName
  location: region
  sku: {
    name: 'standard'
  }
}
