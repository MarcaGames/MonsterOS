#!/bin/bash
mkdir -p output/bootloader;

$HOME/opt/cross/bin/i686-elf-gcc -fno-PIC -ffreestanding -m16 -c bootloader/Boot.cpp -Wall -o output/bootloader/Boot.o
$HOME/opt/cross/bin/nasm bootloader/Bootloader.asm -f elf32 -o output/bootloader/Bootloader.o

ld -melf_i386 --build-id=none -T bootloader/Link.ld output/bootloader/Bootloader.o output/bootloader/Boot.o -o output/bootloader/Bootloader.elf
objcopy -O binary output/bootloader/Bootloader.elf output/bootloader/Bootloader.bin

#ld --oformat binary --build-id=none -T bootloader/Link.ld output/bootloader/Bootloader.o output/bootloader/Boot.o -o output/bootloader/Bootloader.bin

#hexdump output/bootloader/Bootloader.bin
#qemu-system-i386 -hda output/bootloader/Bootloader.bin
