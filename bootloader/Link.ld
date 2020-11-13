OUTPUT_FORMAT("elf32-i386");

ENTRY(start);
SECTIONS
{
	. = 0x7C00;
  .fat32BootSector : {
    /* BIOS Parameter Block */
    output/bootloader/Bootloader.o(.fat32BootSector);
  }

	.firstStageText : {
		output/bootloader/Bootloader.o(.text);
	}

	.firstStageData : SUBALIGN(2) {
		output/bootloader/Bootloader.o(.data);
		output/bootloader/Bootloader.o(.rodata);
	}

	.bootSignature 0x7C00 + 0x200 - 0x2 : {
		SHORT(0xAA55);
	}

  .fat32FSInfoStructureHeader : {
    LONG(0x41615252);
  }

  .fat32FSInfoStructure 0x7C00 + 0x3E4: {
    output/bootloader/Bootloader.o(.fat32FSInfoStructure);
  }

	.text : {
		*(.text);
	}

	.data : SUBALIGN(2) {
		*(.data);
		*(.rodata);
	}

  .bss : SUBALIGN(4) {
		__bss_start = .;
		*(COMMON);
		*(.bss);
		. = ALIGN(4);
		__bss_end = .;
	}
	__bss_sizeb = SIZEOF(.bss);

	/DISCARD/ : {
		*(.eh_frame);
		*(.comment);
	}

	.sig 0x7C00 + (0x200 * 8) - 0x2 : {
		SHORT(0xAA55);
	}
}
