parameterFile="script3.json";

while [ "$1" != "" ]; do
    case $1 in
        -h | --help )       echo "Provide path to parameters file, eg. ./script3.sh script3.json"
                            exit 0
                            ;;
        * )                 parameterFile=$1
                            ;;
    esac
    shift
done

resourceGroup="$(cat $parameterFile | jq -r '.resourceGroup')"
appName="$(cat $parameterFile | jq -r '.appName')";
storageName="$(cat $parameterFile | jq -r '.storageName')";
frequency="$(cat $parameterFile | jq -r '.frequency')";
retention="$(cat $parameterFile | jq -r '.retention')";
dbName="$(cat $parameterFile | jq -r '.dbName')";
dbType="$(cat $parameterFile | jq -r '.dbType')";
dbConnectionString="$(cat $parameterFile | jq -r '.dbConnectionString')";

if [ "$dbName" != "null" ] || [ $dbName != "" ]; then
    az webapp config backup update                  \
        --resource-group $resourceGroup             \
        --webapp-name $appName                      \
        --container-url $storageName                \
        --frequency $frequency                      \
        --retention $retention                      \
        --retain-one FALSE
else
    az webapp config backup update                  \
        --resource-group $resourceGroup             \
        --webapp-name $appName                      \
        --container-url $storageName                \
        --frequency $frequency                      \
        --retention $retention                      \
        --db-name $dbName                           \
        --db-type $dbType                           \
        --db-connection-string $dbConnectionString  \
        --retain-one FALSE
fi;
