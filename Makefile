ARDMK_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))
MONITOR_CMD ?= picocom
MONITOR_PARAMS ?=  --noreset --hangup --quiet
include  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))Arduino.mk

help: d_help
.PHONY: d_help
d_help:
	@echo "Aditional targets:"
	@echo "  make disassm           - disassmbly target"
disassm:	## disassm code
	find build* -name "*.elf" -type f | sed "s/\(.*\)/avr-objdump --disassemble --source --line-numbers --demangle -z --section=.text  --section=.data --section=.bss \1 > \1.dis ; echo '-> \1.dis'/"|bash
