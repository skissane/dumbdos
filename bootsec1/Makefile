bootsec1.img:	bootsec1.sec
	dd if=/dev/zero bs=1024 count=1440 of=bootsec1.img
	dd if=bootsec1.sec of=bootsec1.img conv=notrunc

bootsec1.sec:	bootsec1.bin
	dd if=bootsec1.bin bs=512 skip=62 of=bootsec1.sec

bootsec1.bin:	bootsec1.o
	i686-elf-objcopy -O binary --only-section=.text bootsec1.o bootsec1.bin

bootsec1.o:	bootsec1.s
	i686-elf-as -o bootsec1.o bootsec1.s

.PHONY: clean
clean:
	rm -f *.img *.bin *.o *.sec
