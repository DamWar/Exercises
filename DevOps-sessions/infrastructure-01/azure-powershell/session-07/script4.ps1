param([string]$parameterFile='script4.json')
$parameters = cat $parameterFile | ConvertFrom-Json

$vnet = Get-AzVirtualNetwork -Name $parameters.vnetName -ResourceGroupName $parameters.resourceGroup
$nsg = Get-AzNetworkSecurityGroup -Name $parameters.nsgName -ResourceGroupName $parameters.resourceGroup

Set-AzVirtualNetworkSubnetConfig -Name $parameters.subnetName -VirtualNetwork $vnet -NetworkSecurityGroup $nsg -AddressPrefix $parameters.addressPrefix

$vnet | Set-AzVirtualNetwork