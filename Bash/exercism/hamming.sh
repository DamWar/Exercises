if [ -z ${1+x} ] || [ -z ${2+x} ]; then
    echo "Usage: hamming.sh <string1> <string2>"
    exit 1    
fi

first="$1"  
second="$2"

if (( ${#first} != ${#second} )); then
    echo "strands must be of equal length"
    exit 1     
fi

hamming=0

for (( i=0; i<${#first}; ++i )); do
    if [[ "${first:i:1}" != "${second:i:1}" ]]; then
        ((++hamming))
    fi
done

echo "$hamming"