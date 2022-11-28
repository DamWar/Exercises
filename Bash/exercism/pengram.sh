input="$1"
input=$(echo $input | tr -cd '[A-Z][a-z]')
alphabetCheck=()

for (( i=0; i<26; ++i )); do
    alphabetCheck+=(false)
done

for (( i=0; i<${#input}; ++i )); do
    current=$(printf "%d\n" \'${input:i:1})

    if (( 64 < current && current < 91 )); then
        alphabetCheck[$((current-65))]=true
    elif (( 96 < current && current < 123 )); then
        alphabetCheck[$((current-97))]=true
    else
        echo "Wrong character"
        exit 1
    fi
done

for (( i=0; i<26; ++i )); do
    if [ ${alphabetCheck[i]} = false ]; then
        echo false
        exit 0
    fi
done

echo true