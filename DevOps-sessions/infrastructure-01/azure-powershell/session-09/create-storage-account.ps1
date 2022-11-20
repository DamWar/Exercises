param([string]$parameterFile='script2.json')
$parameters = cat $parameterFile | ConvertFrom-Json

New-AzStorageAccount                                `
    -Name $parameters.storageName                   `
    -ResourceGroupName $parameters.resourceGroup    `
    -Location $parameters.region                    `
    -SkuName $parameters.storageTier                ;