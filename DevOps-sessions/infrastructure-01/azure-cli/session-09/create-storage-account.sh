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
storageName="$(cat $parameterFile | jq -r '.storageName')";
storageTier="$(cat $parameterFile | jq -r '.storageTier')";

az storage account create                           \
    --name $storageName                             \
    --resource-group $resourceGroup                 \
    --location $region                              \
    --sku $storageTier                              ;
