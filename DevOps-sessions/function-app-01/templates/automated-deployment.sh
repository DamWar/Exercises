resourceGroup="infrastructure-01"


templateFile="function"

az deployment group create                          \
    --name "add-function-app"                       \
    --resource-group "$resourceGroup"               \
    --template-file "$templateFile.json"            \
    --parameters "$templateFile-parameters.json"    \
    --verbose

templateFile="role"

az deployment group create                          \
    --name "add-function-app-role"                  \
    --resource-group "$resourceGroup"               \
    --file "$templateFile.json"                     \
    --parameters "$templateFile-parameters.json"    \
    --verbose