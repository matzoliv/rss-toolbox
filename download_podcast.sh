#!/bin/bash

dest_dir=$1

mkdir -p $dest_dir

while IFS=$'\t' read -r id timestamp title url; do
    ( cd "$dest_dir" && curl --compressed -L -s "$url" -O -J )
    printf '%s\t%s\t%s\t%s\n' "$id" "$timestamp" "$title" "$url"
done
