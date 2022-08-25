parameterFile="script2.json";

while [ "$1" != "" ]; do
    case $1 in
        -h | --help )       echo "Provide path to parameters file, eg. ./script2.sh script2.json"
                            ;;
        * )                 parameterFile=$1
                            ;;
    esac
    shift
done

region="$(cat $parameterFile | jq -r '.region')";
vnetName="$(cat $parameterFile | jq -r '.vnetName')";
vnetAddressSpace="$(cat $parameterFile | jq -r '.vnetAddressSpace')";
subnets="$(cat $parameterFile | jq -r '.arrOfSubnets[]')";

arrOfSubnets=();
while read -ra arr; do
    arrOfSubnets+=("${arr[0]}")
done <<< "$subnets";


az network vnet create                  \
--location $region                      \
--name $vnetName                        \
--address-prefixes $vnetAddressSpace    ;    

for ((i = 0 ; i < ${#arrOfSubnets[@]} ; i+=2)); do
    az network vnet subnet create --vnet-name $vnetName --name ${arrOfSubnets[$i]} --address-prefixes ${arrOfSubnets[$((i+1))]}
done
