resourceGroup="infrastructure-01"


templateFile="logic"

az deployment group create                          \
    --name "add-logic-app"                          \
    --resource-group "$resourceGroup"               \
    --template-file "$templateFile.json"            \
    --parameters "$templateFile-parameters.json"    \
    --verbose

templateFile="role"

az deployment group create                          \
    --name "add-logic-app-role"                     \
    --resource-group "$resourceGroup"               \
    --template-file "$templateFile.json"            \
    --parameters "$templateFile-parameters.json"    \
    --verbose