input="$1"
output=""

for (( i=${#input}-1; i>=0; --i )); do
    output+=${input:i:1}
done

echo "$output"