parameterFile="script5.json";

while [ "$1" != "" ]; do
    case $1 in
        -h | --help )       echo "Provide path to parameters file, eg. ./script5.sh script5.json"
                            exit 0
                            ;;
        * )                 parameterFile=$1
                            ;;
    esac
    shift
done

region="$(cat $parameterFile | jq -r '.region')";
resourceGroup="$(cat $parameterFile | jq -r '.resourceGroup')";
vmName="$(cat $parameterFile | jq -r '.vmName')";
vmDiskName="$(cat $parameterFile | jq -r '.vmDiskName')";
vnetName="$(cat $parameterFile | jq -r '.vnetName')";
subnetName="$(cat $parameterFile | jq -r '.subnetName')";
vmTier="$(cat $parameterFile | jq -r '.vmTier')";
vmDiskTier="$(cat $parameterFile | jq -r '.vmDiskTier')";
vmDiskSizeGb="$(cat $parameterFile | jq -r '.vmDiskSizeGb')";
image="$(cat $parameterFile | jq -r '.image')";
imageType="$(cat $parameterFile | jq -r '.imageType')";
publicDnsName="$(cat $parameterFile | jq -r '.publicDnsName')";
reservedIp="$(cat $parameterFile | jq -r '.reservedIp')";

diskName="$vmName-disk"
: ${diskName:=$vmDiskName}

az disk create --name $diskName --resource-group $resourceGroup --tier $vmDiskTier --size-gb $vmDiskSizeGb --image-reference $image

vm="az vm create                    \
  --resource-group $resourceGroup   \
  --name $vmName                    \
  --size $vmTier                    \
  --attach-os-disk $diskName        \
  --vnet-name $vnetName             \
  --subnet $subnetName              \
  --os-type $imageType"

if [ "$publicDnsName" != "null" ] && [ $publicDnsName != "" ]; then
    vm="$vm\
    --public-ip-address-dns-name $publicDnsName"
fi;

if [ "$reservedIp" != "null" ] && [ $reservedIp != "" ]; then
    vm="$vm\
    --public-ip-address-allocation $reservedIp"
fi;

$vm