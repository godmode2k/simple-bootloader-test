#!/bin/sh



#BASE_PATH=$HOME/qemu-7.2.11
#QEMU_BIN=$BASE_PATH/qemu-system-arm
#QEMU_BIN_AARCH64=$BASE_PATH/qemu-system-aarch64
#

BASE_PATH=$HOME/test_arm_work
BIOS_PATH=$BASE_PATH/qemu-7.2.11-prebuilt/pc-bios
QEMU_BIN=$BASE_PATH/qemu-system-arm-7.2.11
QEMU_BIN_AARCH64=$BASE_PATH/qemu-system-aarch64-7.2.11
#
#BASE_PATH=$HOME/test_arm_work
#BIOS_PATH=$BASE_PATH/qemu-9.0.0-prebuilt/pc-bios
#QEMU_BIN=$BASE_PATH/qemu-system-arm-9.0.0
#QEMU_BIN_AARCH64=$BASE_PATH/qemu-system-aarch64-9.0.0


REMOTE_DEBUG="-S -gdb tcp::1234,ipv4"


<<COMMENT
$QEMU_BIN \
    -M vexpress-a9 \
    -m 256M \
    -kernel ./linux-5.4.277/arch/arm/boot/zImage \
    -dtb ./linux-5.4.277/arch/arm/boot/dts/vexpress-v2p-ca9.dtb \
    -sd ./busybox-1.36.1/rootfs.img \
    -append "root=/dev/mmcblk0 rw /bin/sh console=ttyAMA0,115200" \
    -nographic
COMMENT

#$QEMU_BIN -M vexpress-a9 -m 128M -kernel custom-boot.bin -nographic
#$QEMU_BIN -L $BIOS_PATH -M virt -cpu cortex-a15 -m 128M -nographic custom-boot.bin 
#$QEMU_BIN -M versatilepb -cpu cortex-a15 -m 128M -kernel custom-boot.bin -nographic $REMOTE_DEBUG
#$QEMU_BIN -M versatilepb -m 128M -nographic $REMOTE_DEBUG -kernel custom-boot.bin 

#$QEMU_BIN -M microbit -nographic $REMOTE_DEBUG -kernel bootloader.elf

#$QEMU_BIN -M versatilepb -m 128M -nographic $REMOTE_DEBUG -kernel custom-boot.bin 
#$QEMU_BIN -M versatilepb -m 128M -nographic $REMOTE_DEBUG -kernel bootloader.bin
#
#$QEMU_BIN -M versatilepb -cpu cortex-a15 -nographic -kernel bootloader2.elf
$QEMU_BIN -M versatilepb -cpu cortex-a15 -nographic -kernel bootloader2.bin



