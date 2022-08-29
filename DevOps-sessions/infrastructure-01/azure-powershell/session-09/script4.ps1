param([string]$parameterFile='script4.json')
$parameters = cat $parameterFile | ConvertFrom-Json

$resources = Get-AzResource -ResourceGroupName $parameters.resourceGroup
foreach ($resource in $resources) {
    Remove-AzResource -ResourceId $resource.id -Force
}