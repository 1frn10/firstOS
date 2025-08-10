[bits 32]
[extern bmain]

_start_kernel:
	call bmain
	jmp $