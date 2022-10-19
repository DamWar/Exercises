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

vnetName="$(cat $parameterFile | jq -r '.vnetName')";
subnetName="$(cat $parameterFile | jq -r '.subnetName')";
nsgName="$(cat $parameterFile | jq -r '.nsgName')";


az network vnet subnet update   \
--vnet-name $vnetName           \
--name $subnetName              \
--nsg $nsgName                  ;    
