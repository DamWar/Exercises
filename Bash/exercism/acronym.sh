input="$1"

input=$(echo "$input" | tr -cd '[:space:][A-Z][a-z]-')
output="${input:0:1}"

for (( i=0; (i+1)<${#input}; ++i)); do
    if [[ ${input:i:1} == [[:space:]] ]] || [[ ${input:i:1} == '-' ]]; then
        output+=${input:i+1:1}
    fi
done

output=$(echo "$output" | tr -d '[:space:]-')
echo ${output^^}