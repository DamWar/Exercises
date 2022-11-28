sound=""         

if (( $1 % 3 == 0 )); then
    sound+="Pling"   
fi
if (( $1 % 5 == 0 )); then
    sound+="Plang"
fi
if (( $1 % 7 == 0 )); then
    sound+="Plong"
fi

if [ -z $sound ]; then
    echo "$1"
else
    echo "$sound"
fi