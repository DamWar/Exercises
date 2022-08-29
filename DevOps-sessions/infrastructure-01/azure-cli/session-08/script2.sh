parameterFile="script2.json";

while [ "$1" != "" ]; do
    case $1 in
        -h | --help )       echo "Provide path to parameters file, eg. ./script2.sh script2.json"
                            exit 0
							;;
        * )                 parameterFile=$1
                            ;;
    esac
    shift
done

region="$(cat $parameterFile | jq -r '.region')";
resourceGroup="$(cat $parameterFile | jq -r '.resourceGroup')"
appName="$(cat $parameterFile | jq -r '.appName')";
appTier="$(cat $parameterFile | jq -r '.appTier')";
instanceCount="$(cat $parameterFile | jq -r '.instanceCount')";
dockerImage="$(cat $parameterFile | jq -r '.dockerImage')";
planName="$appName-plan";

az appservice plan create                           \
    --name $planName                                \
    --resource-group $resourceGroup                 \
    --sku $appTier                                  ;

az webapp create                                    \
    --name $appName                                 \
    --plan $planName                                \
    --resource-group $resourceGroup                 \
    --deployment-container-image-name $dockerImage  ;

if [ $instanceCount -gt 1 ]; then
    az webapp scale                                 \
        --instance-count $instanceCount             \
        --name $appName                             \
        --resource-group $resourceGroup             ;
fi

