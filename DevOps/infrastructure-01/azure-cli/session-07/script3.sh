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

region="$(cat $parameterFile | jq -r '.region')";
nsgName="$(cat $parameterFile | jq -r '.nsgName')";
rules="$(cat $parameterFile | jq -r '.arrOfRules[]')";

arrOfRules=();
while read -ra arr; do
    arrOfRules+=("${arr[0]}")
done <<< "$rules";


az network nsg create                   \
    --location $region                  \
    --name $nsgName                     ;    

for ((i = 0 ; i+8 < ${#arrOfRules[@]}; i+=9)); do
    destAddress='*'
    destPort="80"
    direction="Inbound"
    protocol='*'
    srcAddress='*'
    srcPort='*'
    access="Allow"

    : ${ruleName:=${arrOfRules[$i]}}
    : ${priority:=${arrOfRules[(($i+1))]}}
    : ${destAddress:={$arrOfRules[(($i+2))]}}
    : ${destPort:=${arrOfRules[(($i+3))]}}
    : ${direction:=${arrOfRules[(($i+4))]}}
    : ${protocol:=${arrOfRules[(($i+5))]}}
    : ${srcAddress:=${arrOfRules[(($i+6))]}}
    : ${srcPort:=${arrOfRules[(($i+7))]}}
    : ${destPort:=${arrOfRules[(($i+8))]}}

    az network nsg rule create                        \
        --nsg-name "$nsgName"                         \
        --name "$ruleName"                            \
        --priority "$priority"                        \
        --destination-address-prefixes "$destAddress" \
        --destination-port-ranges "$destPort"         \
        --direction "$direction"                      \
        --protocol "$protocol"                        \
        --source-address-prefixes "$srcAddress"       \
        --source-port-ranges "$srcPort"               \
        --access "$access"                            ;
done


        