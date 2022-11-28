if [[ !(-z "${1+x}") ]]; then
    if [ -z "${2+x}" ]; then
        echo "Hello, $1"
    else
        echo "Usage: error_handling.sh <person>"
        exit 1
    fi
else
    echo "Usage: error_handling.sh <person>" # possibly for different message
    exit 1
fi