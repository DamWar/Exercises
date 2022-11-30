param region string = 'westeurope'
param planName string = 'exampleplan'
param appName string
param planTier string = 'B1'
param nodesInWebFarm int = 1
param dockerHubImage string = 'nginx:alpine'

param serverName string
param dbName string
param dbTier string = 'S1'
param adminLogin string
@secure()
param adminPassword string
param dbBackupPolicy object
param firewallRules array

param storageName string
param storageTier string = 'Standard_LRS'

param scheduleAndRetention object


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

module database '../modules/sql-db.bicep' = {
  name: 'add-sql-db'
  params: {
    region: region
    serverName: serverName
    dbName: dbName
    dbTier: dbTier
    adminLogin: adminLogin
    adminPassword: adminPassword
    dbBackupPolicy: dbBackupPolicy
    firewallRules: firewallRules
  }
}

module storageAccount '../modules/storage-account.bicep' = {
  name: 'add-storage-account'
  params: {
    region: region
    storageName: storageName
    storageTier: storageTier
  }
}

resource backup 'Microsoft.Web/sites/config@2020-06-01' = {
  name: '${appName}/backup'
  kind: 'backup'
  properties: {
    backupName: 'app-bu'
    backupSchedule: scheduleAndRetention
    databases: [
      {
        connectionString: 'Server=tcp:${database.outputs.fqdn},1433; Initial Catalog=${dbName}; Persist Security Info=False; User Id=${adminLogin}@${serverName}; Password=${adminPassword}; Encrypt=True; Connection Timeout=30'
        connectionStringName: 'conn-str'
        databaseType: 'SqlAzure'
        name: database.name
      }
    ]
    enabled: true
    storageAccountUrl: storageAccount.outputs.connection
  }
}

