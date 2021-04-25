#!/bin/bash

dest_dir=$1

mkdir -p $dest_dir

while IFS=$'\t' read -r id timestamp title url; do
    ( cd "$dest_dir" && youtube-dl -f bestvideo[ext=mp4]+bestaudio[ext=m4a] --merge-output-format mp4 "$url" )
    printf '%s\t%s\t%s\t%s\n' "$id" "$timestamp" "$title" "$url"
done
