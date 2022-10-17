deploy () {
    az deployment group create                      \
    --name "$1"                                     \
    --resource-group "$2"                           \
    --template-file "$3.json"                       \
    --parameters "parameters.json"                  \
    --verbose
}
resourceGroup="infrastructure-01"
deployAutomation () {
    deploy "add-automation-$1" $resourceGroup "$1" 
}


deployAutomation "account"
deployAutomation "host-01-schedules"
deployAutomation "host-02-schedules"
deployAutomation "role"