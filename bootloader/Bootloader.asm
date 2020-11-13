extern ___BiosPrint
extern ___BootMain
global start
bits 16

section .fat32BootSector
; BIOS Parameter Block
jmp short start
nop                     ; 3 Bytes:  "jmp short start; nop;".
db "MSWIN4.1"           ; 8 Bytes:  OEM Identifier.
dw 0x200                ; 2 Bytes:  Bytes per sector.
db 0x8                  ; 1 Byte:   Sectors per cluster.
dw 0x203E               ; 2 Bytes:  Reserved sectors.
db 0x2                  ; 1 Byte:   FAT's on the storage media.
dw 0x0                  ; 2 Bytes:  Number of Directory entries.
dw 0x0                  ; 2 Bytes:  The total sectors in the logical volume.
db 0xF8                 ; 1 Byte:   Media Descriptor Type.
dw 0x0                  ; 2 Bytes:  Sectors per FAT. FAT12/FAT16 only.
dw 0x3F                 ; 2 Bytes:  Sectors per track.
dw 0xFF                 ; 2 Bytes:  Heads or Sides on the storage media.
dd 0x0                  ; 4 Bytes:  Number of hidden sectors.
dd 0x7FE000             ; 4 Bytes:  Large sector count.
; Fat32 Extended Boot Record
dd 0x1FE1               ; 4 Bytes:  Sectors per FAT.
dw 0x0                  ; 2 Bytes:  Flags.
dw 0x0                  ; 2 Bytes:  Fat version number.
dd 0x2                  ; 4 Bytes:  Cluster number of the root directory.
dw 0x1                  ; 2 Bytes:  Sector number of the FSInfo structure.
dw 0x6                  ; 2 Bytes:  Sector number of the backup boot sector.
dd 0x0, 0x0, 0x0        ; 12 Bytes: Reserved.
db 0x80                 ; 1 Byte:   Drive number.
db 0x0                  ; 1 Byte:   Reserved.
db 0x29                 ; 1 Byte:   Signature.
dd 0x2223987F           ; 4 Bytes:  Volume ID 'Serial' number.
db "MOSBoot    "        ; 11 Bytes: Volume label string.
db "FAT32   "           ; 8 Bytes:  System identifier. Always "Fat32   ".

section .fat32FSInfoStructure
dd 0x61417272
dd 0xFEFFA
dd 0x8
dd 0x0, 0x0, 0x0
dd 0xAA550000

section .text
start:
  xor ax, ax
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov sp, 0x7C00
  jmp 0x0000:setcs	; Set CS to 0

setcs:
  cld             ; GCC code requires direction flag to be cleared
  mov bx, 0x07E0
  mov es, bx
  xor bx, bx
  mov ah, 2
  mov al, 7       ; Load the next 1 sectors into memory
  mov ch, 0
  mov cl, 2       ; Start at sector 2. (index=1)
  mov dh, 0
  int 0x13

  jc sectorReadError
  push dword welcomeMsg
  call dword ___BiosPrint ; Call print function
  call dword ___BootMain  ; Call BootMain in C++
  cmp eax, 0x0
  je hang

  push dword errorMsg
  call dword ___BiosPrint ; Call print function
  jmp hang

sectorReadError:
  mov si, errorMsg
  sectorReadError_Body:
    lodsb
    or al, al
    jz hang
    mov ah, 0x0E
    mov bh, 0x0
    int 0x10
    jmp sectorReadError_Body

hang:
  cli
  hlt
  jmp hang

section .rodata
welcomeMsg db "Loaded MonsterBooter!", 13, 10, 0
errorMsg db "Failed to load MonsterBooter!", 13, 10, 0
