param([string]$parameterFile='script5.json')
$parameters = cat $parameterFile | ConvertFrom-Json

$vmName = $parameters.vmName
$vmDiskName = "$vmName-disk"
$nicName = "$vmName-nic"
$ipConfigName = "$vmName-ipconf"
$pipName = "$vmName-pip"
$imageType = $parameters.imageType
$resourceGroup = $parameters.resourceGroup
$region = $parameters.region
$reservedIp = $parameters.reservedIp
$publicDnsName = $parameters.publicDnsName

$vnet = Get-AzVirtualNetwork -Name $parameters.vnetName -ResourceGroupName $resourceGroup
$Subnet = Get-AzVirtualNetworkSubnetConfig -Name $parameters.subnetName -VirtualNetwork $vnet
if((-not $reservedIp) -or ($reservedIp -eq "null") -or ($reservedIp -eq "")){
    $IPconfig = New-AzNetworkInterfaceIpConfig -Name $ipConfigName -PrivateIpAddressVersion IPv4 -Subnet $Subnet
}else{
    $PIP = New-AzPublicIPAddress -Name $pipName -ResourceGroupName $resourceGroup -Location $region -AllocationMethod $reservedIp
    $IPconfig = New-AzNetworkInterfaceIpConfig -Name $ipConfigName -PublicIpAddress $PIP1 -Subnet $Subnet
}

$NIC = New-AzNetworkInterface -Name $nicName -ResourceGroupName $resourceGroup -Location $region -IpConfiguration $IPconfig

$VMLocalAdminUser = $parameters.adminLogin
$VMLocalAdminSecurePassword = ConvertTo-SecureString $parameters.adminPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($VMLocalAdminUser, $VMLocalAdminSecurePassword);

$VirtualMachine = New-AzVMConfig -VMName $vmName -VMSize $parameters.vmTier
$VirtualMachine = Set-AzVMOSDisk -VM $VirtualMachine -Name $vmDiskName -CreateOption "FromImage"
if($imageType -eq "Windows"){
    $VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName azurePC -Credential $Credential
}else{
    $VirtualMachine = Set-AzVMOperatingSystem -VM $VirtualMachine -Linux -ComputerName azurePC -Credential $Credential
}
$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $NIC.Id
$VirtualMachine = Set-AzVMSourceImage -VM $VirtualMachine -PublisherName $parameters.imagePublisher -Offer $parameters.imageOffer -Skus $parameters.imageSkus -Version $parameters.imageVersion

if((-not $reservedIp) -or ($reservedIp -eq "null") -or ($reservedIp -eq "")){
    New-AzVM -ResourceGroupName $resourceGroup -Location $region -VM $VirtualMachine -Verbose
}else{
    New-AzVM -ResourceGroupName $resourceGroup -Location $region -VM $VirtualMachine -DomainNameLabel $publicDnsName -Verbose
}
