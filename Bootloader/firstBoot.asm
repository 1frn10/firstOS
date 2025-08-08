; First Stage Bootloader

[bits 16]
[org 0x7c00]

start:
	xor ax, ax 
	mov es, ax 
	mov ds, ax 
	mov ss, ax 

	mov [drive_type], dl
	;mov bp, 0x9000
	;mov sp, bp 

	;;; Set 80*25 Text Mode
	mov ah, 0x0 
	mov al, 0x2 
	int 0x10

	xor ax, ax

	;;; Load Kernel From Disk
	;;; At Sector 2 Into Memory
	;;; At Memory Address 0x1000
	mov bx, 0x1000 
	mov al, 0x2
	mov cl, 0x2
	call load_disk

	;;; Load Global Descriptor Table And
	;;; Switch Into 32 Bit Protected Mode
	cli
	lgdt [m_GdtDesc]
	mov eax, cr0
	or eax, 1 
	mov cr0, eax
	jmp CODE_SEG:.protected_mode

[bits 32]
.protected_mode:
	mov ax, DATA_SEG
	mov ds, ax 
	mov es, ax 
	mov fs, ax 
	mov gs, ax 
	mov ss, ax 

	;mov ebp, 0x90000
	;mov esp, ebp

	mov byte [0xb8000], 'X'
	mov byte [0xb8004], 'Z'
	jmp 0x1000
	jmp $



[bits 16]
;;;Load Disk Using BIOS INT 13H
load_disk:
	pusha 
	mov ch, 0x0 
	mov dh, 0x0 
	mov dl, [drive_type]
	mov ah, 0x2
	int 0x13
	jc .error 
	jmp .end

.error:
	jmp $

.end:
	popa
	ret


m_Gdt:
    dq 0x0

m_GdtCode:
    dw 0xFFFF   
    dw 0x0       
    db 0x0     
    db 10011010b 
    db 11001111b 
    db 0x0       

m_GdtData:
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0


m_GdtDesc:
    dw 0x17 
    dd m_Gdt

CODE_SEG equ 0x8
DATA_SEG equ 0x10

drive_type: db 0

times 510 - ($-$$) db 0
dw 0xaa55