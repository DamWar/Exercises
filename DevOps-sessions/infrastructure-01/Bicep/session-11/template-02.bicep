param region string = 'westeurope'
param serverName string
param dbName string
param dbTier string = 'S1'
param dbBackupPolicy object
param firewallRules array


resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: serverName
  location: region
  properties: {
      administratorLogin: 'azureuser'
      administratorLoginPassword: 'P455/w0rd'
      version: '12.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  parent: sqlServer
  name: dbName
  location: region
  sku: {
      name: dbTier
  }
  properties: {
      collation: 'SQL_Latin1_General_CP1_CI_AS'
      maxSizeBytes: 1073741824
  }
} 

resource sqlBackupPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2022-02-01-preview' = {
  parent: sqlDatabase
  name: 'Default'
  properties: dbBackupPolicy
}

resource sqlFirewallRules 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = [for i in range(0, length(firewallRules)): {
  parent: sqlServer
  name: 'ipRule${i}'
  properties: firewallRules[i]
}]
