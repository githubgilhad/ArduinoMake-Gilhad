ARDMK_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))
MONITOR_CMD ?= picocom
MONITOR_PARAMS ?=  --flow n --noreset --quiet
ISP_PROG ?= usbasp
include  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))Arduino.mk

# Makro pro získání dat z gitu
GIT_DESCRIBE := $(shell git describe --tags --long 2>/dev/null || echo "v0.0.0-0-g0000000")
GIT_COMMIT_HASH := $(shell git rev-parse --short HEAD)
GIT_COMMIT_MESSAGE := $(shell git log -1 --pretty=%s)
VERSION_HEADER := version.h

# Cíl pro generování version.h
$(VERSION_HEADER): FORCE
	@echo "Checking version..."
	@TMPFILE=$$(mktemp) && \
	echo "#pragma once" > $$TMPFILE && \
	echo "#define VERSION_STRING \"$(GIT_DESCRIBE)++\"" >> $$TMPFILE && \
	echo "#define VERSION_COMMIT \"$(GIT_COMMIT_HASH)\"" >> $$TMPFILE && \
	echo "#define VERSION_MESSAGE \"$(GIT_COMMIT_MESSAGE)\"" >> $$TMPFILE && \
	if ! cmp -s $$TMPFILE $(VERSION_HEADER); then \
		echo "Updating $(VERSION_HEADER)"; \
		mv $$TMPFILE $(VERSION_HEADER); \
	else \
		echo "$(VERSION_HEADER) is up to date"; \
		rm $$TMPFILE; \
	fi


# Umožní vždy ověřit stav
FORCE:

# Cíl pro návrh nového tagu
new_tag:
	@LAST_TAG=$$(git tag --sort=-v:refname | head -n1); \
	if [ -z "$$LAST_TAG" ]; then \
		NEW_TAG="v0.0.1"; \
	else \
		IFS=. read -r MAJOR MINOR PATCH <<< "$$(echo $$LAST_TAG | sed 's/^v//')"; \
		PATCH=$$((PATCH + 1)); \
		NEW_TAG="v$${MAJOR}.$${MINOR}.$${PATCH}"; \
	fi; \
	echo "Suggested new tag:"; \
	echo "git tag -a $$NEW_TAG -m \"Release $$NEW_TAG\""; \
	echo "git push origin $$NEW_TAG"

# Cíl pro ruční vygenerování nové verze
version: $(VERSION_HEADER)
help: d_help
.PHONY: d_help FORCE new_tag version monitor upload_monitor
d_help:
	@echo "Aditional targets:"
	@echo "  make disassm           - disassmbly target"
	@echo "  make pico              - open serial connection"
	@echo "  make upload_monitor    - upload and monitor"
	@echo "  make version           - make/update version.h"
	@echo "  make new_tag           - suggest new tag for git"
disassm:	## disassm code
	find build* -name "*.elf" -type f | sed "s/\(.*\)/avr-objdump --disassemble --source --line-numbers --demangle -z --section=.text  --section=.data --section=.bss \1 > \1.dis ; echo '-> \1.dis'/"|bash
pico:
	# picocom -b 115200 --flow n  --noreset --hangup --quiet /dev/ttyUSB0
	picocom -b 115200 --flow n  --noreset --quiet /dev/ttyUSB0
upload_monitor: upload monitor
