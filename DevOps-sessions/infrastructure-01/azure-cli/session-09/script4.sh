parameterFile="script4.json";

while [ "$1" != "" ]; do
    case $1 in
        -h | --help )       echo "Provide path to parameters file, eg. ./script4.sh script4.json"
                            exit 0
                            ;;
        * )                 parameterFile=$1
                            ;;
    esac
    shift
done

resourceGroup="$(cat $parameterFile | jq -r '.resourceGroup')"

resourcesJson="az resource list --resource-group $resourceGroup"
resources="$($resourcesJson | jq -r '.[].id')"


# for resource in $resources; do
#     resource="$(echo $resource | grep subscription)"
#     if [ ! -z $resource ]; then
#         echo $resource
#     fi
# done

for ((i=0;i<6;i++)); do
    resourcesJson="az resource list --resource-group $resourceGroup"
    resources="$($resourcesJson | jq -r '.[].id')"
    for resource in $resources; do
        resource="$(echo $resource | grep subscription)"
        if [ ! -z $resource ]; then
            az resource delete --ids "$resource"
        fi
    done
done