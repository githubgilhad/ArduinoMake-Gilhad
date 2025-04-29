#!/usr/bin/python -u
# vim: fileencoding=utf-8:nomodified:nowrap:textwidth=0:foldmethod=marker:foldcolumn=4:ruler:showcmd:lcs=tab\:|- list:tabstop=8:noexpandtab:nosmarttab:softtabstop=0:shiftwidth=0
import sys

def process_size_output(input_lines):
    flash_text = 0
    flash_data = 0
    ram_data = 0
    ram_bss = 0
    filename = ""

    # Procházení všech řádků ve vstupu
    for line in input_lines:
        columns = line.split()
        if len(columns) < 6:
            continue  # přeskočíme neúplné řádky

        # Získání názvu souboru
        if filename == "" and columns[-1].endswith('.elf'):
            filename = columns[-1]
        
        # Zpracování řádku pro .elf soubor
        if columns[-1].endswith('.elf'):
            text = int(columns[0])
            data = int(columns[1])
            bss = int(columns[2])
            # Přičítáme hodnoty
            flash_text = text
            flash_data = data
            ram_bss = bss


    # Vytvoření výstupu
    if filename:
        print(f"        |   size |   hexa | {filename}")
        print(f"--------+--------+--------+--------------------------")
        print(f"FLASH: 	| {flash_text + flash_data:6} | 0x{flash_text + flash_data:04X} | data: {flash_data} + text: {flash_text}")
        print(f"RAM:   	| {flash_data + ram_bss:6} | 0x{flash_data + ram_bss:04X} | data: {flash_data} + bss: {ram_bss}")

if __name__ == "__main__":
    input_lines = sys.stdin.read().strip().split("\n")
    process_size_output(input_lines)


