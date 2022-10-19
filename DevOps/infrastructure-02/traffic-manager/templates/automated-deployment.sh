templateFile="traffic-manager"

az deployment group create                      \
--name "add-traffic-manager"                    \
--resource-group "infrastructure-01"            \
--template-file "$templateFile.json"            \
--parameters "$templateFile-parameters.json"    \
--verbose