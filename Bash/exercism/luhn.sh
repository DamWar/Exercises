input=$(echo "$1" | tr -cd '[0-9]')
inputLength=${#input}
inputPurge=$(echo "$1" | tr -d '[0-9] ')

if [[ ! (-z $inputPurge) ]] || (( inputLength < 2 )); then
    echo false
    exit 0
fi

#replace with new digits
for (( i=inputLength-2; i>=0; i=i-2 )); do
    outputDigit=$((${input:i:1}*2))
    if (( outputDigit > 9 )); then
        outputDigit=$((outputDigit-9))
    fi
    input=$(echo $input | sed s/./$outputDigit/$((i+1)))
done
#add digits
output=0
for (( i=0; i<inputLength; ++i )); do
    output=$((output + ${input:i:1}))
done

if (( output % 10 == 0 )); then
    echo true
else
    echo false
fi