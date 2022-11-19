param([string]$parameterFile='script2.json')
$parameters = cat $parameterFile | ConvertFrom-Json

$resourceGroup = $parameters.resourceGroup
$appName = $parameters.appName
$planName = "$appName-plan"
$instanceCount = $parameters.instanceCount

New-AzAppservicePlan                        `
    -Name $planName                         `
    -ResourceGroupName $resourceGroup       `
    -Location $parameters.region            `
    -Tier $parameters.appTier               ;

New-AzWebApp                                `
    -Name $appName                          `
    -ResourceGroupName $resourceGroup       `
    -Location $parameters.region            `
    -AppServicePlan $planName               ;

if( $instanceCount -gt 1 ){
    Set-AzAppServicePlan                    `
        -NumberofWorkers $instanceCount     `
        -Name $planName                     `
        -ResourceGroupName $resourceGroup   ;
}