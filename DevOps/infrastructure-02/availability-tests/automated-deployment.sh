appInsightsName=
templateFile="availability-tests"

az deployment group create                      \
--name "add-$templateFile"                      \
--resource-group "infrastructure-01"            \
--template-file "$templateFile.json"            \
--parameters "$templateFile-parameters.json"    \
--parameters appInsightsName="appInsight"       \
--verbose