deploy () {
    az deployment group create                      \
    --name "$1"                                     \
    --resource-group "$2"                           \
    --template-file "$3.json"                       \
    --parameters "parameters.json"                  \
    --parameters appName=$4 scheduleNamePrefix=$4   \
    --verbose
}
resourceGroup="infrastructure-01"
deployAutomation () {
    deploy "add-automation-$1" $resourceGroup "$1" $2
}


deployAutomation "links" host-01
deployAutomation "links" host-02