#
# This Makefile is not called from Opam but only used for
# convenience during development
#

DUNE 	= dune

.PHONY: all install test clean uninstall format

all:
	$(DUNE) build

install: all
	$(DUNE) install

uninstall:
	$(DUNE) uninstall

test:
	$(DUNE) runtest

deps:
	opam install . --deps-only

clean:
	$(DUNE) clean

utop:
	$(DUNE) utop

format:
	$(DUNE) build --auto-promote @fmt
	dune format-dune-file dune-project > $$$$ && mv $$$$ dune-project
	opam lint
	git ls-files '**/*.[ch]' | xargs -n1 indent -nut -i8

changes:
	git log "$$(git describe --tags --abbrev=0)..HEAD" --pretty=format:"* %s"

release:
	dune-release tag
	dune-release distrib
	dune-release opam pkg
	echo 'use "dune-release opam submit" to release on Opam'

# vim:ts=8:noet:
