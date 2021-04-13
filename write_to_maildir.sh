#!/bin/bash

from=$1
maildir_path=$2

mmkdir "$maildir_path"

while IFS=$'\t' read -r id timestamp title url; do
    rfcdate=$(date --date @$timestamp -R)
    created=$(cat <<ENDMARKER | mdeliver -v "$maildir_path"
From: $from
To: $EMAIL
Date: $rfcdate
Subject: $title

$url
ENDMARKER
)
    touch --date="$rfcdate" -m "$created" > /dev/null
    printf '%s\t%s\t%s\t%s\n' "$id" "$timestamp" "$title" "$url"
done
