patchFileName="patch"
exportPath="./"
nParentDirectoriesToCut="-p1"
deletepatchFile=true

exitIfEmptyOrUnset(){
	if [ -z $1 ]; then
		echo "Missing essential parameter(s)"
		exit 1
	fi
}

while [ "$1" != "" ]; do
	case "$1" in
		-n | --patchFileName)
			shift
			patchFileName=$1
			;;
		-e | --exportPath)
			shift
			exportPath=$1
			;;
		-i | --importPath)
			shift
			importPath=$1
			;;
		-d | --importSubdirectory)
			shift
			importSubdirectory=$1
			;;
		-p | --nParentDirectoriesToCut)
			shift
			nParentDirectoriesToCut="-p$1"
			;;
		-s)
			deletepatchFile=false
			;;
		*)
			echo "Invalid parameter $1"
			exit 1
			;;
	esac
	shift
done

exitIfEmptyOrUnset $importPath
exitIfEmptyOrUnset $importSubdirectory

git log --pretty=email --patch-with-stat --reverse --full-index --binary -m --first-parent -- "$exportPath" > "$importPath/$patchFileName"
cd "$importPath"
git am --committer-date-is-author-date "$nParentDirectoriesToCut" --directory="$importSubdirectory" < "$patchFileName"
if "$deletepatchFile"; then
	rm "$patchFileName"
fi