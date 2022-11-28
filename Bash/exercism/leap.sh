input="$1"

#input sanitization (sort of)
if [[ !(-z ${2+x}) ]] || [[ -z $input ]] || [[ $(echo "$input" | tr -d '[0-9]') != "" ]]; then
    echo "Usage: leap.sh <year>"
    exit 1
fi

if (( input % 4 == 0 )) && (( input % 100 != 0 || input % 400 == 0 )); then
    echo true
else
    echo false
fi