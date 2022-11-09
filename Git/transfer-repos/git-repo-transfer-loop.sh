path="."

for filename in */; do
	filename=${filename%?}
	select="(,|^)( )*$filename(\/)?( )*(,|$)"
	if grep -P -q "$select" exclude.csv; then
		echo "Excluded $filename"
	else
		cd "$filename"
		../git-repo-transfer.sh --importPath "../$1" --importSubdirectory "$path/$filename"
		cd ..
	fi
done