#!/bin/bash

set -x

EMAIL=example@example.com

mkdir -p store

process_blog() {
    curl --compressed -L -s "$1" \
	| "$3" \
	| ./print_new_update.py "store/$2.seen" \
	| ./write_to_maildir.sh "$2@rss" ./mail/blogs/ \
        | ./make_pdfs.sh "./kindle/$2/"
}

cat - << EOF | while read line; do process_blog $line; done
https://ferd.ca/feed.rss ferd ./feed2tsv/rss2tsv.py
http://feeds.feedburner.com/TheCRPGAddict?format=xml crpgaddict ./feed2tsv/atom2tsv.py
EOF

process_podcast() {
    curl --compressed -L -s "$1" \
	| "$3" \
	| ./print_new_update.py "store/$2.seen" \
	| ./write_to_maildir.sh "$2@podcast" ./mail/podcasts/ \
        | ./download_podcast.sh "./podcasts/$2/"
}

cat - << EOF | while read line; do process_podcast $line; done
https://atp.fm/rss atp ./feed2tsv/rss2tsv_enclosure.py
EOF

process_youtube() {
    curl --compressed -L -s "$1" \
	| "$3" \
	| ./print_new_update.py "store/$2.seen" \
	| ./write_to_maildir.sh "$2@youtube" ./mail/rss/youtube/ \
        | ./backup_youtube.sh "/videos/$2/"
}

cat - << EOF | while read line; do process_youtube $line; done
https://www.youtube.com/feeds/videos.xml?channel_id=UCDYZxJE8kLZ-o6nL8E1bXdQ matn ./feed2tsv/atom2tsv.py
https://www.youtube.com/feeds/videos.xml?channel_id=UCgRBRE1DUP2w7HTH9j_L4OQ medlifecrisis ./feed2tsv/atom2tsv.py
EOF

sleep 1

mbsync -a fastmail
