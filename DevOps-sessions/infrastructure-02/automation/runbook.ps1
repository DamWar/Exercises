param(
	[string] $resourceGroupName,
	[string] $appName,
	[string] $desiredState
)


try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

$currentState = Get-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName | Select-Object -Property "state"
$currentState = $currentState.state

if($currentState -eq "Running"){
	$currentState = "on"
}elseif($currentState -eq "Stopped"){
	$currentState = "off"
}

if($currentState -eq $desiredState){
	Write-Error -Message "App is already in the desired state"
}else{
	if($desiredState -eq "on"){
		Start-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName
	}elseif($desiredState -eq "off"){
		Stop-AzWebApp -ResourceGroupName $resourceGroupName -Name $appName
	}else{
		Write-Error -Message "Invalid desired state. Please provide value 'on' or 'off'"
	}
}
