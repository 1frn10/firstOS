[bits 32]

mov byte [0xb8002], 'Y'

jmp $

times 1024 - ($-$$) db 0