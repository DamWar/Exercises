input="$1"

total=1
onSquare=1

# bash integer overflows at about 2^63
if [[ $input == "total" ]]; then
    bc <<< "2^64-1"
elif (( input == 64 )); then
    bc <<< "2^63"
elif (( 1 < input && input < 64 )); then
    ((++input))
    for (( i=2; i<input; ++i )); do
        onSquare=$((onSquare*2))
    done
    echo $onSquare
elif (( input == 1 )); then
    echo 1
else
    echo "Error: invalid input"
    exit 1
fi