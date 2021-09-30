#!/bin/bash

scriptdir=$(dirname $(realpath "$0"))

usage() {
    echo "Usage: url2mobi.sh [ -o output.mobi ] [ -t \"A Title\" ] url1 url2 ..."
}

output_dest=$(realpath .)

while getopts ":o:t:" o; do
    case "${o}" in
        o)
	    output_dest=$(realpath ${OPTARG})
            ;;
        t)
            output_title=${OPTARG}
            ;;
        *)
            usage
	    exit 1
            ;;
    esac
done
shift $((OPTIND-1))

if [ "$#" -lt 1 ]; then
    usage
    exit 1
fi

workspace=$(mktemp -d)

cleanup() {
    if [ "$?" -ne "0" ]; then
	echo "urleink failed"
    fi

    rm -rf $workspace
}

trap cleanup EXIT

if [ -n "$COOKIES" ]; then
    COOKIES_OPTIONS="--load-cookies $COOKIES"
else
    COOKIES_OPTIONS=
fi

function download_page {
    url=$1
    args=$2

    resultfile=$(wget --compression=auto -E -H -k -K -p $COOKIES_OPTIONS -A '*.html,*.jpg,*.jpeg,*.png,*.gif' "$url" 2>&1 > /dev/null \
        | grep -E '^Saving to: ' \
        | head -n 1 \
        | sed -E 's/^Saving to: ‘(.*)’$/\1/')

    if [ -n "$resultfile" ]; then
	echo "$resultfile"
    else
	return 1
    fi
}

function make_readable {
    url=$1

    >&2 echo "processing $url"
    url_workspace=$(mktemp -d XXXXXXXX)
    pushd $url_workspace > /dev/null
    page=$(download_page "$url") || exit 1
    >&2 echo "downloaded $url"
    readablepage="$page.readable.html"

    title=$(node $scriptdir/make-readable/get-title.js < "$page")

    >&2 echo "will be using title: $title"

    cat > "$readablepage" <<EOF
<html>
  <head></head>
  <body>
  <h1>$title</h1>

  <h2>$url</h2>
EOF

    node $scriptdir/make-readable/make-readable.js < "$page" >> "$readablepage" || exit 1
    >&2 echo "made readable"

    cat >> "$readablepage" <<EOF
  </body>
</html>
EOF
    popd > /dev/null

    printf "%s\t%s\n" "$title" "$url_workspace/$readablepage"
}

cd $workspace

if [ "$#" -gt 1 ]; then
    echo "<html><body><ul>" > index.html
    for url in $*; do
	IFS=$'\t' read title page < <(make_readable $url)
	if [ -z "$output_title" ]; then
	   output_title=$title
	fi
	echo "<li><a href=\"$page\">$title</a></li>" >> index.html
    done
    echo "</ul></body></html>" >> index.html
    readablepage=index.html
else
    IFS=$'\t' read title page < <(make_readable $1)
    if [ -z "$output_title" ]; then
	output_title=$title
    fi
    readablepage=$page
fi

if [ -d "$output_dest" ]; then
    sanitizedtitle=$(echo -n "$output_title" | tr -c [:alnum:] _)
    outputfile="$output_dest/${sanitizedtitle}_$(mktemp -u XXXXXXXX).mobi"
else
    outputfile="$output_dest"
fi

ebook-convert "$readablepage" "$outputfile" --title "$output_title" 2>&1 > /dev/null || exit 1

echo "created ebook $outputfile"
