BIN_DIR = bin/
BOOT_DIR = Bootloader/
KERNEL_DIR = Kernel/

all = $(BIN_DIR)OS.bin $(BIN_DIR)kernel_entry.o $(BIN_DIR)firstboot.o clean

$(BIN_DIR)OS.bin: $(BIN_DIR)firstboot.o $(BIN_DIR)kernel_entry.o 
	cat $^ > $@ 

$(BIN_DIR)kernel_entry.o: $(KERNEL_DIR)entry.asm
	nasm -f bin $< -o $@

$(BIN_DIR)firstboot.o: $(BOOT_DIR)firstBoot.asm
	nasm -f bin $< -o $@

run: $(BIN_DIR)OS.bin
	qemu-system-i386 -drive format=raw,file=$<

clean:
	rm -f $(BIN_DIR)*.o OS.bin