SHELL   := /bin/bash
PACKAGE := $(shell perl -aF: -ne 'print, exit if s/^Package:\s+//' DESCRIPTION)
VERSION := $(shell perl -aF: -ne 'print, exit if s/^Version:\s+//' DESCRIPTION)
BUILD   := $(PACKAGE)_$(VERSION).tar.gz

.PHONY: build install $(BUILD)
compile:
	find src/ -type f -exec chmod 644 {} \;
	Rscript -e "library(Rcpp); compileAttributes('.');"
	Rscript -e "devtools::load_all(); roxygen2::roxygenise('.');"
	find . -iname "*.a" -exec rm {} \;
	find . -iname "*.o" -exec rm {} \;
	find . -iname "*.so" -exec rm {} \;

build:
	# autoconf
	# chmod 755 cleanup
	# chmod 755 configure
	find src/ -type f -exec chmod 644 {} \;
	chmod 644 DESCRIPTION Makefile NAMESPACE README.md
	# ./configure
	# ./cleanup
	Rscript -e "library(Rcpp); compileAttributes('.');"
	Rscript -e "devtools::load_all(); roxygen2::roxygenise('.');"
	find . -iname "*.a" -exec rm {} \;
	find . -iname "*.o" -exec rm {} \;
	find . -iname "*.so" -exec rm {} \;
	R CMD build .

install:
	# autoconf
	# chmod 755 cleanup
	# chmod 755 configure
	find src/ -type f -exec chmod 644 {} \;
	chmod 644 DESCRIPTION Makefile NAMESPACE README.md
	# ./configure
	# ./cleanup
	Rscript -e "library(Rcpp); compileAttributes('.');"
	Rscript -e "devtools::load_all(); roxygen2::roxygenise('.');"
	find . -iname "*.a" -exec rm {} \;
	find . -iname "*.o" -exec rm {} \;
	find . -iname "*.so" -exec rm {} \;
	R CMD build . # --no-build-vignettes
	R CMD INSTALL $(BUILD)

