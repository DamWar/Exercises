input="$1"

score01=('A' 'E' 'I' 'O' 'U' 'L' 'N' 'R' 'S' 'T')
score02=('D' 'G')
score03=('B' 'C' 'M' 'P')
score04=('F' 'H' 'V' 'W' 'Y')
score05=('K')
score08=('J' 'X')
score10=('Q' 'Z')

score=0
addScore(){
    letterToCompare=$1
    nPoints=$2
    shift 2
    letterArray=$@
    if [[ " ${letterArray[*]} " =~ " ${letterToCompare^^} " ]]; then
        score=$((score+$nPoints))
        return 1
    fi
}

for (( i=0; i<${#input}; ++i )); do
    letter=${input:i:1}
    addScore $letter 1 ${score01[@]} || continue
    addScore $letter 2 ${score02[@]} || continue
    addScore $letter 3 ${score03[@]} || continue
    addScore $letter 4 ${score04[@]} || continue
    addScore $letter 5 ${score05[@]} || continue
    addScore $letter 8 ${score08[@]} || continue
    addScore $letter 10 ${score10[@]} || continue
done;

echo $score