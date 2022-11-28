input=$1       

if (( input == 0 || input == 1 )); then
    echo $input
    exit 0       
fi

i=1
result=1     

while (( result <= input )); do
    ((++i))
    result=$((i*i))
done

echo $((i-1))