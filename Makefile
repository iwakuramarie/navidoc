VERSION=1.11.1
CFLAGS+=-g -DVERSION='"$(VERSION)"' -Wall -Wextra -Werror -Wno-unused-parameter
LDFLAGS+=-static
INCLUDE+=-Iinclude
PREFIX?=/usr/local
_INSTDIR=$(DESTDIR)$(PREFIX)
BINDIR?=$(_INSTDIR)/bin
MANDIR?=$(_INSTDIR)/share/man
PCDIR?=$(_INSTDIR)/lib/pkgconfig
OUTDIR=.build
HOST_NAVIDOC=./navidoc
.DEFAULT_GOAL=all

OBJECTS=\
	$(OUTDIR)/main.o \
	$(OUTDIR)/string.o \
	$(OUTDIR)/utf8_chsize.o \
	$(OUTDIR)/utf8_decode.o \
	$(OUTDIR)/utf8_encode.o \
	$(OUTDIR)/utf8_fgetch.o \
	$(OUTDIR)/utf8_fputch.o \
	$(OUTDIR)/utf8_size.o \
	$(OUTDIR)/util.o

$(OUTDIR)/%.o: src/%.c
	@mkdir -p $(OUTDIR)
	$(CC) -std=c99 -pedantic -c -o $@ $(CFLAGS) $(INCLUDE) $<

navidoc: $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $^

navidoc.1: navidoc.1.nvd $(HOST_NAVIDOC)
	$(HOST_NAVIDOC) < $< > $@

navidoc.5: navidoc.5.nvd $(HOST_NAVIDOC)
	$(HOST_NAVIDOC) < $< > $@

navidoc.pc: navidoc.pc.in
	sed -e 's:@prefix@:$(PREFIX):g' -e 's:@version@:$(VERSION):g' < $< > $@

all: navidoc navidoc.1 navidoc.5 navidoc.pc

clean:
	rm -rf $(OUTDIR) navidoc navidoc.1 navidoc.5 navidoc.pc

install: all
	mkdir -p $(BINDIR) $(MANDIR)/man1 $(MANDIR)/man5 $(PCDIR)
	install -m755 navidoc $(BINDIR)/navidoc
	install -m644 navidoc.1 $(MANDIR)/man1/navidoc.1
	install -m644 navidoc.5 $(MANDIR)/man5/navidoc.5
	install -m644 navidoc.pc $(PCDIR)/navidoc.pc

check: navidoc navidoc.1 navidoc.5
	@find test -perm -111 -exec '{}' \;

.PHONY: all clean install check
