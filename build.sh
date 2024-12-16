#!/bin/sh

GCC_BIN=arm-none-linux-gnueabihf-gcc
AS_BIN=arm-none-linux-gnueabihf-as
LD_BIN=arm-none-linux-gnueabihf-ld
OBJCOPY_BIN=arm-none-linux-gnueabihf-objcopy
OBJDUMP_BIN=arm-none-linux-gnueabihf-objdump
SIZE_BIN=arm-none-linux-gnueabihf-size

# "-mcpu=cortex-a8 -march=armv7-a -mfpu=neon"
#ARM_OPTS="-marm -march=armv7-a -mcpu=cortex-a8"
#ARM_OPTS="-march=armv7-m"
#ARM_OPTS="-march=armv7-m -mcpu=cortex-m3 -mthumb" # ARM EABI
#ARM_OPTS="-mcpu=cortex-m0plus -mthumb"
#
#CFLAGS="-g -Wall -Werror -O0 -ffreestanding -ffunction-sections -fdata-sections"
#LDFLAGS="-Wl,--gc-sections -static -nostdlib"
CFLAGS="-g -Wall -Werror -O0"
LDFLAGS="-Wl,--gc-sections -static"
OPTS="$ARM_OPTS $CFLAGS $LDFLAGS"


# ----------------------------------
# Build
# ----------------------------------
echo "build ..."
echo "-> bootloader..."
$AS_BIN -g -o startup.o startup.s
if [ "$?" = "1" ]; then exit; fi
$GCC_BIN $OPTS -c -o bootloader2.o bootloader2.c
if [ "$?" = "1" ]; then exit; fi
$LD_BIN -Map bootloader2.map -T bootloader2.ld -o bootloader2.elf startup.o bootloader2.o
if [ "$?" = "1" ]; then exit; fi
$OBJDUMP_BIN -D bootloader2.elf > bootloader2.list
if [ "$?" = "1" ]; then exit; fi
echo


# ----------------------------------
# .elf to .bin
# ----------------------------------
echo
echo "objcopy: .elf to .bin ..."
echo "-> bootloader..."
$OBJCOPY_BIN bootloader2.elf bootloader2.bin
#
# QEMU: works good .bin without '-O binary'
#$OBJCOPY_BIN --pad-to=0x4000 --gap-fill=0xFF bootloader2.elf bootloader2.bin
#
# QEMU: does not work .bin with '-O binary' (USE .elf)
#$OBJCOPY_BIN -O binary bootloader2.elf bootloader2.bin
if [ "$?" = "1" ]; then exit; fi
echo


# ----------------------------------
# Size
# ----------------------------------
echo
echo "size ..."
$SIZE_BIN bootloader2.bin
echo


# ----------------------------------
# Concatenate
# ----------------------------------
#echo
#echo "concatenate ..."
#echo "bootloader.bin + app.bin: custom-boot.bin"
#cat bootloader.bin >> custom-boot.bin
#if [ "$?" = "1" ]; then exit; fi
#cat app.bin >> custom-boot.bin
#if [ "$?" = "1" ]; then exit; fi
#echo


# ----------------------------------
# Image file
# ----------------------------------
#echo "image for flash ..."
#echo "bootloader2.bin -> bootloader2.img"
#dd of=bootloader.img bs=128k count=128 if=/dev/zero
#dd of=bootloader.img bs=128k conv=notrunc if=bootloader2.bin
#echo


echo "run qemu ..."
echo "$ qemu-system-arm -M versatilepb -cpu cortex-a15 -nographic -kernel <output>.bin"
echo


