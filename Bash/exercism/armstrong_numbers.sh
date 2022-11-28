input="$1"
inputLength=${#input}
armstrong=0

for (( i=0; i<inputLength; ++i )); do
    current=$(echo "${input:i:1}^$inputLength" | bc)
    armstrong=$((armstrong + current))
done

if [ $armstrong == $input ]; then
    echo true
else
    echo false
fi