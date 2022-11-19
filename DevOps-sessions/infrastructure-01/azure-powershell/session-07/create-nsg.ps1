param([string]$parameterFile='script3.json')
$parameters = cat $parameterFile | ConvertFrom-Json

function assignParamOrDefault($param, $default){
    $str = if((-not $param) -and ($param -eq ''))
            {$default}
        else
            {$param}
    return "${str}"
}

$nsg = New-AzNetworkSecurityGroup -Name $parameters.nsgName -ResourceGroupName $parameters.resourceGroup  -Location  $parameters.region

for (($i = 0); ($i+8) -lt $parameters.arrOfRules.Count; $i+=9){
    $ruleName = $parameters.arrOfRules[$i]
    $priority = $parameters.arrOfRules[($i+1)]
    $destAddress = assignParamOrDefault $parameters.arrOfRules[($i+2)] '*'
    $destPort = assignParamOrDefault $parameters.arrOfRules[($i+3)] "80"
    $direction = assignParamOrDefault $parameters.arrOfRules[($i+4)] "Inbound"
    $protocol = assignParamOrDefault $parameters.arrOfRules[($i+5)] '*'
    $srcAddress = assignParamOrDefault $parameters.arrOfRules[($i+6)] '*'
    $srcPort = assignParamOrDefault $parameters.arrOfRules[($i+7)] '*'
    $access = assignParamOrDefault $parameters.arrOfRules[($i+8)] "Allow"

    $nsg | Add-AzNetworkSecurityRuleConfig      `
        -Name $ruleName                         `
        -Priority $priority                     `
        -DestinationAddressPrefix $destAddress  `
        -DestinationPortRange $destPort         `
        -Direction $direction                   `
        -Protocol $protocol                     `
        -SourceAddressPrefix $srcAddress        `
        -SourcePortRange $srcPort               `
        -Access $access                       
}

$nsg | Set-AzNetworkSecurityGroup
