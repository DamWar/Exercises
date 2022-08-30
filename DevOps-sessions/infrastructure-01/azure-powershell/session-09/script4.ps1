param([string]$parameterFile='script4.json')
$parameters = cat $parameterFile | ConvertFrom-Json

$safetyCount = 0

while(($resources = Get-AzResource -ResourceGroupName $parameters.resourceGroup) -and ($resources -ne "")){
    foreach ($resource in $resources) {
        Remove-AzResource -ResourceId $resource.id -Force
    }
    if($safetyCount++ -ge 5){
        echo "Script executed unexpected amount of times. Please make sure you want to continue and execute the script again if needed."
        exit 0
    }
}
