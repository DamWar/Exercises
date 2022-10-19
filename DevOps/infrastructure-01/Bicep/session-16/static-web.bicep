param region string = 'westeurope'
param storageName string
param storageTier string = 'Standard_LRS'

param indexDocument string
param errorDocument404 string

var storageAccountContributor = subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '17d1049b-9a84-46fb-8f53-869881c3d3ab')


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

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'damwar-identity-01'
  location: region
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  scope: storageAccount
  name: guid(resourceGroup().id, storageAccountContributor)
  properties: {
    roleDefinitionId: storageAccountContributor
    principalId: managedIdentity.properties.principalId
  }
}

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'enable-static-website'
  location: region
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}' : {}
    }
  }
  properties: {
    azPowerShellVersion: '3.0'
    scriptContent:  '''
                    param(
                      [string] $resourceGroupName,
                      [string] $storageName,
                      [string] $indexDocument,
                      [string] $errorDocument404
                    )
                    

                    $storageAccount = Get-AzStorageAccount      `
                    -ResourceGroupName $resourceGroupName       `
                    -AccountName $storageName                   

                    $ctx = $storageAccount.Context

                    Enable-AzStorageStaticWebsite               `
                    -Context $ctx                               `
                    -IndexDocument $indexDocument               `
                    -ErrorDocument404Path $errorDocument404 
                    '''
    retentionInterval: 'P1D'
    arguments: '-ResourceGroupName "${resourceGroup().name}" -storageName "${storageName}" -IndexDocument "${indexDocument}" -errorDocument404 "${errorDocument404}"'
  }
  dependsOn: [storageAccount]
}
