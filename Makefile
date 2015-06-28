CC=arm-elf-gcc-4.7
CFLAGS=-mfpu=neon -march=armv7-a -O2
ASFLAGS=$(CFLAGS) -c

test: doLinearScaler.o doLinearScaler_Row.o
	$(CC) $(CFLAGS) -o $@ $^

clean:
	$(RM)	*.o test
