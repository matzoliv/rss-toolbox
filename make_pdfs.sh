#!/bin/bash

dest_dir=$1

mkdir -p "$dest_dir"

while IFS=$'\t' read -r id timestamp title url; do
    node ./url2pdf/index.js "$url" "$dest_dir $(echo $title | tr -dc '[:alnum:] ') - $(uuidgen | head -c 6).pdf" > /dev/null
    printf '%s\t%s\t%s\t%s\n' "$id" "$timestamp" "$title" "$url"
done
