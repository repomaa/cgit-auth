CRYSTAL := /usr/bin/crystal

all:
	source ./config && \
		$(CRYSTAL) build src/cgit-auth.cr

release:
	source ./config && \
		$(CRYSTAL) build --release src/cgit-auth.cr
