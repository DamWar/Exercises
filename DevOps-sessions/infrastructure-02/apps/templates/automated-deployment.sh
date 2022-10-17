deploy () {
    az deployment group create                      \
    --name "$1"                                     \
    --resource-group "$2"                           \
    --template-file "apps.json"                     \
    --parameters "$3-parameters.json"               \
    --verbose
}
resourceGroup="infrastructure-01"

deployAutomation () {
    deploy "add-app-$1" $resourceGroup "$1" 
}


deployAutomation "host-01"
deployAutomation "host-02"
deployAutomation "dr"