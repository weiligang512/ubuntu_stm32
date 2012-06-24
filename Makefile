SRC 	:= ./
INC 	:= ./

CROSS_COMPILE 	?= arm-none-eabi-
#CROSS_COMPILE 	?=

CC 		= $(CROSS_COMPILE)gcc
LD 		= $(CROSS_COMPILE)ld
OBJCOPY	= $(CROSS_COMPILE)objcopy


NOSTART = -nostartfiles
CPU 	= cortex-m3
CFLAG	= -mcpu=$(CPU) -mthumb -Wall -fdump-rtl-expand
LDFLAG  = -mcpu=$(CPU) -T ./stm32_flash.ld

SOURCE		= $(SRC)/%.c
INCLUDE 	= $(wildcard $(INC)/%.h)
OBJ			= startup_stm32f10x_hd.o core_cm3.o system_stm32f10x.o \
			  misc.o stm32f10x_gpio.o stm32f10x_rcc.o stm32f10x_it.o main.o

OBJELF		= main
OBJBIN		= $(OBJELF).bin

all: $(OBJBIN)

$(OBJBIN): $(OBJELF)
	$(OBJCOPY) -O binary -S -R .comment	$< $@

$(OBJELF): $(OBJ)
	$(CC) $(LDFLAG) -I$(INC) $(OBJ) -o $(OBJELF)

startup_stm32f10x_hd.o: $(SRC)/startup_stm32f10x_hd.s
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

core_cm3.o: $(SRC)/core_cm3.c $(INC)/core_cm3.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

system_stm32f10x.o: $(SRC)/system_stm32f10x.c $(INC)/system_stm32f10x.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f10x_it.o: $(SRC)/stm32f10x_it.c $(INC)/stm32f10x_it.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

misc.o: $(SRC)/misc.c $(INC)/misc.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f10x_gpio.o: $(SRC)/stm32f10x_gpio.c $(INC)/stm32f10x_gpio.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

stm32f10x_rcc.o: $(SRC)/stm32f10x_rcc.c $(INC)/stm32f10x_rcc.h
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

main.o: $(SRC)/main.c
	$(CC) $(CFLAG) -I$(INC) -c $< -o $@ 

.PHONY: clean

clean:
	rm -rf *.o $(OBJELF) $(OBJBIN) *.expand



