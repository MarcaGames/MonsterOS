[ORG 0x7C00]
jmp short start
nop
times 0x5A - ($ - $$) - 2 db 0
dw 0xF0FA

start:
	xor ax, ax
	mov ds, ax
	cld

	mov bx, 0x8000
	mov es, bx
	xor bx, bx
	mov ah, 2
	mov al, 7		; Load the next 7 sectors into memory
	mov ch, 0
	mov cl, 2		; Start at the 2 sector. (index=1)
	mov dh, 0
	int 0x13
	jc error
	call bootLoaderStart
	jmp hang

error:
	mov si, errorMsg
	lodsb
	or al, al
	jz hang
	mov ah, 0x0E
	mov bh, 0
	int 0x10
	jmp error

hang:
	hlt
	jmp hang

errorMsg db "Failed to load bootloader!", 13, 10, 0
times 0x200 - ($ - $$) - 2 db 0
dd 0xAA55

times 0x400 - ($ - $$) - 2 db 0
dd 0xAA55

bios_print:
	lodsb
	or al, al
	jz done
	mov ah, 0Eh
	mov bh, 0
	int 10h
	jmp bios_print
done:
	ret

startupMsg db "Monster Bootloader startup", 13, 10, 0

bootLoaderStart:
;	Setup 16-bit segment registers and stack

;	Print startup message
	mov si, startupMsg
	call bios_print
;	Check presence of PCI, CPUID, MSRs

;	Enable and confirm enabled A20 line

;	Load GDTR

;	Inform BIOS of target processor mode

;	Get memory map from BIOS

;	Locate kernel in filesystem

;	Allocate memory to load kernel image

;	Load kernel image into buffer

;	Enable graphics mode

;	Check kernel image ELF headers

;	Enable long mode, if 64-bit

;	Allocate and map memory for kernel segments

;	Setup stack

;	Setup COM serial output port

;	Setup IDT

;	Disable PIC

;	Check presence of CPU features (NX, SMEP, x87, PCID, global pages, TCE, WP, MMX, SSE, SYSCALL), and enable thhem

;	Assign a PAT to write combining

;	Setup FS/GS base

;	Load IDTR

;	Enable APIC and setup using information in ACPI tables

;	Setup GDT and TSS

times 0x1000 - ($ - $$) db 0
