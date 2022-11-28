input=$(echo "${2,,}" | tr -cd '[0-9][a-z]')

output=""

for (( i=0; i<${#input}; ++i )); do
    #that if part is probably poorly optimized but additional compare operations don't matter much and code looks far better this way
    if (( i % 5 == 0 && i != 0 )) && [[ "$1" == "encode" ]]; then
        output+=" "
    fi
    current=${input:i:1}
    if [[ $current == [0-9] ]]; then
        output+=$current
    else
        currentLetter=$(printf "%d\n" \'$current) #97-122 expected
        currentLetter=$(( 122-(currentLetter-97) )) #just to reverse the alphabet
        output+=$(printf "\x$(printf %x $currentLetter)")
    fi
done

echo $output