templateFile="function"

az deployment group create                          \
    --name "add-function-app"                       \
    --resource-group "infrastructure-03"            \
    --template-file "$templateFile.json"            \
    --parameters "$templateFile-parameters.json"    \
    --verbose

templateFile="role"

az deployment group create                          \
    --name "add-function-app-role"                  \
    --resource-group "infrastructure-03"            \
    --template-file "$templateFile.json"            \
    --parameters "$templateFile-parameters.json"    \
    --verbose