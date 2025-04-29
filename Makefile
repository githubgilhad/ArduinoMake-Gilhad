ARDMK_DIR:=$(dir $(realpath $(lastword $(MAKEFILE_LIST))))
include  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))Arduino.mk
disassm:	## disassm code
	find build* -name "*.elf" -type f | sed "s/\(.*\)/avr-objdump --disassemble --source --line-numbers --demangle -z --section=.text  --section=.data --section=.bss \1 > \1.dis ; echo '-> \1.dis'/"|bash
