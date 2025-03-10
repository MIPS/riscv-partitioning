# Makefile for RISC-V Doc Template
#
# This work is licensed under the Creative Commons Attribution-ShareAlike 4.0
# International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-sa/4.0/ or send a letter to
# Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
#
# SPDX-License-Identifier: CC-BY-SA-4.0
#
# Description:
#
# This Makefile is designed to automate the process of building and packaging
# the Doc Template for RISC-V Extensions.

# Change these if you want;
# - DOC is output name and src/$(DOC).adoc is the primary input
# - DESTDIR is created/destroyed, choose it accordingly, or I'll pick one
# - for f in FORMATS, $(ASCIIDOCTOR_$f) is a build command to run
# - CONTIMG is the <img> name passed to docker-run
DOC := riscv-partitioning
#DESTDIR := ${PWD}/build
#DESTDIR := /mnt/c/Users/$(shell whoami)/Downloads/$(DOC)
FORMATS := PDF HTML
CONTIMG := riscvintl/riscv-docs-base-container-image:latest

# If not specified, pick a useful default
ifeq (,$(DESTDIR))
ifneq (,$(wildcard /mnt/c/Users/$(shell whoami)/Downloads))
DESTDIR := /mnt/c/Users/$(shell whoami)/Downloads/$(DOC)
else
DESTDIR := ${PWD}/build
endif
endif

# Change these if you must;
ASCIIDOCTOR_PDF := asciidoctor-pdf
ASCIIDOCTOR_HTML := asciidoctor
OPTIONS := --trace \
	-a compress \
	-a allow-uri-read \
	-a mathematical-format=svg \
	-a pdf-fontsdir=/inputs/docs-resources/fonts \
	-a pdf-theme=/inputs/docs-resources/themes/riscv-pdf.yml \
	-D /outputs \
	--failure-level=ERROR \
	--require=asciidoctor-diagram \
	--require=asciidoctor-mathematical \
	--require=asciidoctor-kroki
TOUCHFILE := $(DESTDIR)/buildcmd

# Change these at your peril;
# - PWD is mounted-read-only, so docker's blast-radius is DESTDIR
# - PWD/src/$(DOC).adoc is the primary source file
# - Output is made dependent on all files inside PWD/src/
DOCKER_QUOTE := "
ifeq (,$(VERBOSE))
V := @
else
V :=
endif
BUILDCMD := docker run --rm \
	-v ${PWD}:/inputs:ro \
	-v $(DESTDIR):/outputs \
	$(CONTIMG) /bin/sh -c \
	$(DOCKER_QUOTE) \
	$(foreach e,$(FORMATS),$(ASCIIDOCTOR_$(e)) $(OPTIONS) /inputs/src/$(DOC).adoc && )true \
	$(DOCKER_QUOTE)
CLEANCMD := docker run --rm \
	-v $(DESTDIR):/outputs \
	$(CONTIMG) /bin/sh -c \
	$(DOCKER_QUOTE) \
	rm -rf /outputs/* \
	$(DOCKER_QUOTE) && rmdir $(DESTDIR)
DEPS := $(shell find ${PWD}/src -type f)

# Remove the touchfile if any aspect of the build command has changed (FORMATS,
# asciidoctor options, container image, ...).
ifneq (,$(wildcard $(TOUCHFILE)))
$(shell echo 'BUILDCMD := $(BUILDCMD)' > $(TOUCHFILE).tmp)
$(shell cmp $(TOUCHFILE) $(TOUCHFILE).tmp > /dev/null 2>&1 || rm -f $(TOUCHFILE))
$(shell rm -f $(TOUCHFILE).tmp)
endif

.PHONY: all build clean

all: build

build: $(TOUCHFILE)

# TBD: remove the sed line when copyright is no longer redirected to MIPS
$(TOUCHFILE): $(DEPS) | $(DESTDIR)
	@echo "[BUILD $(DOC) -> $(DESTDIR)]"
	$(V)$(BUILDCMD)
	$(V)echo 'BUILDCMD := $(BUILDCMD)' > $@

$(DESTDIR):
	$(V)mkdir -p $@

ifeq (,$(wildcard $(DESTDIR)))
clean:
else
clean:
	@echo "Cleaning up generated files..."
	$(V)$(CLEANCMD)
	@echo "Cleanup completed."
endif
