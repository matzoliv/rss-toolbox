.PHONY: check all

make-readable/readability:
	git clone https://github.com/mozilla/readability.git ./make-readable/readability

all: check make-readable/readability
	cd make-readable && npm install

check:
	which ebook-convert
	which wget
	which npm
