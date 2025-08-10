BIN_DIR = bin/
BOOT_DIR = Bootloader/
KERNEL_DIR = Kernel/


all =$(BIN_DIR)OS.bin $(BIN_DIR)kernel_entry.o $(BIN_DIR)firstboot.o clean

KERNEL_OBJS = \
			$(BIN_DIR)kernel_entry.o \
			$(BIN_DIR)kernel_stdio.o \
			$(BIN_DIR)kernel_x86.o 	 \
			$(BIN_DIR)kernel_string.o\
			$(BIN_DIR)kernel_main.o  \

$(BIN_DIR)OS.bin: $(BIN_DIR)firstboot.o $(BIN_DIR)kernel.o
	dd if=/dev/zero of=$(BIN_DIR)OS.bin bs=512 count=2880
	dd if=$(BIN_DIR)firstboot.o of=$(BIN_DIR)OS.bin seek=0 conv=notrunc count=1
	dd if=$(BIN_DIR)kernel.o of=$(BIN_DIR)OS.bin seek=1 conv=notrunc count=2

$(BIN_DIR)kernel.o: $(KERNEL_OBJS)
	i686-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

$(BIN_DIR)kernel_entry.o: $(KERNEL_DIR)entry.asm
	nasm -f elf $< -o $@

$(BIN_DIR)kernel_main.o: $(KERNEL_DIR)main.c
	i686-elf-gcc -c -ffreestanding -m32 $< -o $@

$(BIN_DIR)kernel_stdio.o: $(KERNEL_DIR)stdio.c
	i686-elf-gcc -c -ffreestanding -m32 $< -o $@

$(BIN_DIR)kernel_x86.o: $(KERNEL_DIR)x86.c
	i686-elf-gcc -c -ffreestanding -m32 $< -o $@

$(BIN_DIR)kernel_string.o: $(KERNEL_DIR)string.c
	i686-elf-gcc -c -ffreestanding -m32 $< -o $@

$(BIN_DIR)firstboot.o: $(BOOT_DIR)firstBoot.asm
	nasm -f bin $< -o $@

run: $(BIN_DIR)OS.bin
	qemu-system-i386 -drive format=raw,file=$<

clean:
	rm -f $(BIN_DIR)*.o OS.bin
