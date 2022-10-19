appinsights=$1
webapp=$2
region=$3
resourcegroup=$4

az monitor app-insights component create --app $appinsights --location $region --resource-group $resourcegroup
instrumentationKey=(az monitor app-insights component show --app $appinsights --resource-group $resourcegroup --query  "instrumentationKey" --output tsv)
az webapp config appsettings set --name $webapp --resource-group $resourcegroup --settings APPINSIGHTS_INSTRUMENTATIONKEY=$instrumentationKey APPLICATIONINSIGHTS_CONNECTION_STRING=InstrumentationKey=$instrumentationKey ApplicationInsightsAgent_EXTENSION_VERSION=~2