param([string]$parameterFile='script2.json')
$parameters = cat $parameterFile | ConvertFrom-Json


$vnet = @{
    Name = $parameters.vnetName
    ResourceGroupName = $parameters.resourceGroup
    Location = $parameters.region
    AddressPrefix = $parameters.vnetAddressSpace
}
$virtualNetwork = New-AzVirtualNetwork @vnet

for (($i = 0); $i -lt $parameters.arrOfSubnets.Count; $i+=2){
    $subnet = @{
        Name = $parameters.arrOfSubnets[$i]
        VirtualNetwork = $virtualNetwork
        AddressPrefix = $parameters.arrOfSubnets[($i+1)]
    }
    $subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet
} 

$virtualNetwork | Set-AzVirtualNetwork