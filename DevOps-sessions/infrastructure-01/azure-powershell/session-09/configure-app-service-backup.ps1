param([string]$parameterFile='script3.json')
$parameters = cat $parameterFile | ConvertFrom-Json

$resourceGroup = $parameters.resourceGroup
$appName = $parameters.appName
$storageName = $parameters.storageName
$frequencyInterval = $parameters.frequencyInterval
$frequencyUnit = $parameters.frequencyUnit
$retention = $parameters.retention
$dbConn = $parameters.dbConnectionString

if((-not $dbConn) -or ($dbConn -eq "null") -or ($dbConn -eq "")){
    Edit-AzWebAppBackupConfiguration            `
        -ResourceGroupName $resourceGroup       `
        -Name $appName                          `
        -StorageAccountUrl $storageName         `
        -FrequencyInterval $frequencyInterval   `
        -FrequencyUnit $frequencyUnit           `
        -RetentionPeriodInDays $retention       ;
}else{
    $db = New-AzWebAppDatabaseBackupSetting     `
        -Name $appName                          `
        -ConnectionString $dbConn               `
        -DatabaseType $parameters.dbType        ;

    Edit-AzWebAppBackupConfiguration            `
        -ResourceGroupName $resourceGroup       `
        -Name $appName                          `
        -StorageAccountUrl $storageName         `
        -FrequencyInterval $frequencyInterval   `
        -FrequencyUnit $frequencyUnit           `
        -RetentionPeriodInDays $retention       `
        -Databases $db                          ;
}


