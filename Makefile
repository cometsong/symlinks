# Makefile for symlinks

CC := gcc
PREFIX := /usr/local
BIN_DIR := $(PREFIX)/bin
MAN_DIR := $(PREFIX)/share/man

INSTALL := install
INSTALL_PROGRAM := $(INSTALL) -c -m 0755
INSTALL_DATA := $(INSTALL) -c -m 0644

PROGRAM_NAME := symlinks

manext = 8
manname = $(PROGRAM_NAME).$(manext)

COMPILER_OPTIONS := -Wall -Wstrict-prototypes -O2 -fstrict-aliasing -pipe
CFLAGS := $(COMPILER_OPTIONS) $(CFLAGS_CONFIG) $(CFLAGS_EXTRA)

.PHONY: all
all: symlinks

symlinks: symlinks.c
	$(CC) $(CFLAGS) -o $(PROGRAM_NAME) symlinks.c

install: all $(manname)
	$(INSTALL_PROGRAM) symlinks $(DESTDIR)$(BIN_DIR)/$(PROGRAM_NAME)
	$(INSTALL_DATA) $(manname) $(DESTDIR)$(MAN_DIR)/man$(manext)/$(manname)

uninstall:
	rm -f $(DESTDIR)$(BIN_DIR)/$(PROGRAM_NAME)
	rm -f $(DESTDIR)$(MAN_DIR)/man$(manext)/$(manname)

.PHONY: test
test: clean symlinks
	@test/generate-rootfs.sh
	@test/run-tests.sh

.PHONY: clean
clean:
	rm -f $(PROGRAM_NAME) *.o core
	rm -fr test/rootfs
