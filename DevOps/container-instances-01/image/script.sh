az login --service-principal -u $1 -p $2 --tenant $3
for k in $(az webapp list | jq -r '.[] | values | .name'); do
    az webapp restart --name $k
done