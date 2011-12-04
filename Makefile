PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

VERSION = 2.7
DIST =	COPYING README Makefile mobileimap.in ChangeLog

mobileimap: mobileimap.in Makefile
	rm -f mobileimap
	sed -e 's!@VERSION@!$(VERSION)!g' mobileimap.in >mobileimap.tmp 
	mv mobileimap.tmp mobileimap
	chmod +x mobileimap
	chmod -w mobileimap
	ruby -wc mobileimap

install: mobileimap
	cp mobileimap $(BINDIR)
	chmod +x $(BINDIR)/mobileimap

dist: $(DIST)
	rm -rf mobileimap-$(VERSION)
	rm -f mobileimap-$(VERSION).tar.gz

	mkdir mobileimap-$(VERSION)
	cp -rp $(DIST) mobileimap-$(VERSION)

	tar zcf mobileimap-$(VERSION).tar.gz  mobileimap-$(VERSION)
	rm -rf mobileimap-$(VERSION)

update-web:
	mkdir -p web
	cp -rp images/*.png web/images

	make dist
	cp mobileimap-$(VERSION).tar.gz web
