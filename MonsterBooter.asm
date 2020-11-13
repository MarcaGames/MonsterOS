[ORG 0x7C00]
jmp short main
nop
times 0x5A - ($ - $$) - 2 db 0
dw 0xF0FA

main:
	xor ax, ax
	mov ds, ax
	mov sp, 0x9C00

	mov bx, 0x07E0
	mov es, bx
	xor bx, bx
	mov ah, 2
	mov al, 7	; Load the next 7 sectors into memory
	mov ch, 0
	mov cl, 3	; Start at the 3 sector. (index=2)
	mov dh, 0
	int 0x13
	jc .L1
	jmp bootloader_main
	jmp hang
	.L1:
		mov si, errorMsg
		lodsb
		or al, al
		jz hang
		mov ah, 0x0E
		mov bh, 0
		int 0x10
		jmp .L1

hang:
	hlt
	jmp hang

errorMsg db "Failed to load MonsterBooter!", 13, 10, 0
times 0x200 - ($ - $$) - 2 db 0
dw 0xAA55

times 0x400 - ($ - $$) - 2 db 0
dw 0xF0FA

bootloader_main:
	cli
	push ds

	lgdt [gdtinfo]

	mov eax, cr0
	or al, 1
	mov cr0, eax

	mov bx, 0x08
	mov ds, bx

	and al, 0xFE
	mov cr0, eax

	pop ds
	sti

	mov bx, 0x0f01
	mov eax, 0x0b8000
	mov word[ds, eax], bx

	jmp $

gdtinfo:
	dw gdt_end - gdt - 1
	dd gdt

gdt	dd 0, 0
flatdesc dd 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:
