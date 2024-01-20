# Template Makefile for beebScreen projects, add your
# Tools
CC = arm-none-eabi-gcc
LD = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
RM = rm
ECHO = echo

# Temporary file to hold our unconverted binary file
TEMP = temp
TARGET = test

#Uncomment this line for the full fat VFP optimised Raspberry Pi Native ARM co-processor build.
#CFLAGS := -DVFP -nostartfiles -O2 -mfloat-abi=hard -mfpu=vfp -march=armv6zk -mtune=arm1176jzf-s -fno-delete-null-pointer-checks -fdata-sections -ffunction-sections --specs=nano.specs --specs=nosys.specs -u _printf_float

#Uncomment this line for the ARM7TDMI (and BeebEm) compatible build.
CFLAGS := -nostartfiles -O2 -mcpu=arm7tdmi -mtune=arm7tdmi -fno-delete-null-pointer-checks -fdata-sections -ffunction-sections --specs=nano.specs --specs=nosys.specs -u _printf_float

#Uncomment this line if you find minimised enums are breaking your code's data formats. (default is to make enums as small as possible to hold all values)
#CFLAGS += -fno-short-enums

#These flags work with both builds
LD_FLAGS := -Wl,--gc-sections -Wl,--no-print-gc-sections -Wl,-T,rpi.X -Wl,-lm

# Add your object files here
OBJ = main.o

# Beeb coprocessor 
BEEB_OBJ = armc-start.o armtubeio.o armtubeswis.o beebScreen/beebScreen.o

LIB = -lc -lm

$(TARGET): $(OBJ) $(BEEB_OBJ)
	$(CC) $(CFLAGS) $(LD_FLAGS) $(OBJ) $(BEEB_OBJ) $(LIB) -o $(TEMP)
	$(OBJCOPY) -O binary $(TEMP) $@
	$(RM) $(TEMP)
	$(ECHO) $(TARGET) 0000F000 0000F000 > $(TARGET).inf
	$(ECHO) $(TARGET) WR \(0\) F000 F000 > \#\#\#BBC.inf

cleanall: clean depclean 

clean: 
	$(RM) $(OBJ) $(BEEB_OBJ) $(TARGET) beebScreen/*.bin

remake: clean $(TARGET)

beebScreen/beebScreen.o: beebScreen/beebScreen.c beebScreen/beebCode.c beebScreen/beebScreen.h
	$(CC) $(CFLAGS) -c beebScreen/beebScreen.c -o beebScreen/beebScreen.o

beebScreen/beebCode.c: beebScreen/beebCode.bin
	cd beebScreen; ./mkasm

beebScreen/extraCode.c: beebScreen/beebCode.asm beebScreen/extraCode.bin
	cd beebScreen; ./mkasm

beebScreen/beebCode.bin: beebScreen/beebCode.asm

beebScreen/extraCode.bin: beebScreen/beebCode.asm

main.c: beebScreen/beebCode.c beebScreen/extraCode.c

depclean:
	$(RM) $(OBJ:.o=.d)

%.d: %.c
	$(CC) -M -MG $(DEPFLAGS) $< | sed -e 's@ /[^ ]*@@g' -e 's@^\(.*\)\.o:@\1.d \1.o:@' > $@

include $(SRC:.c=.d)
	
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(CC) $(CFLAGS) -c $< -o $@
	

