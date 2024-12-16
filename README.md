# Simple Bootloader test


Reference
----------
```sh
source-based:
 - https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch
 - https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch
 - https://balau82.wordpress.com/2010/02/28/hello-world-for-bare-metal-arm-using-qemu
 - https://www.youtube.com/watch?v=cfNJ85cX-ms
 - https://www.youtube.com/watch?v=3brOzLJmeek
```


Environment
----------
    OS: Ubuntu 20.04 x64 LTS
    VM: QEMU v7.2.11, v9.0.0 (https://www.qemu.org/)
    ARM Toolchain: arm-gnu-toolchain-13.x


ARM Toolchain
----------
```sh
download:
https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads

$ cd $HOME
$ mkdir arm-toolchain
$ cd arm-toolchain

1. AArch32
// arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-linux-gnueabihf
$ wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz?rev=adb0c0238c934aeeaa12c09609c5e6fc&hash=B119DA50CEFE6EE8E0E98B4ADCA4C55F
$ tar xJvf arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz

2. AArch64
// arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu
$ wget https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz?rev=22c39fc25e5541818967b4ff5a09ef3e&hash=B9FEDC2947EB21151985C2DC534ECCEC
$ tar xJvf arm-gnu-toolchain-13.2.rel1-x86_64-aarch64-none-linux-gnu.tar.xz


// AArch32 bare-metal target (arm-none-eabi)
// for gdb (arm-none-eabi-gdb)
$ sudo apt-get install libncursesw5 libncursesw5-dev


// path
$ echo "export PATH=$PATH:/home/arm-toolchain/arm-gnu-toolchain-13.2.Rel1-x86_64-aarch64-none-linux-gnu/bin" >> $HOME/.profile
$ echo "export PATH=$PATH:/home/arm-toolchain/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-linux-gnueabihf/bin" >> $HOME/.profile
$ source $HOME/.profile
```


QEMU Build Instructions
----------
```sh
$ cd $HOME

$ sudo apt-get update
$ sudo apt-get install build-essential gdb gdb-multiarch
$ sudo apt-get install python3 python3-pip ninja-build
$ sudo apt-get install pkg-config libglib2.0-dev
$ sudo apt-get install libslirp-dev
$ sudo apt-get install libpixman-1-dev
$ pip install sphinx
$ pip install sphinx_rtd_theme

// download QEMU 7.2.11, 9.0.0
$ wget https://download.qemu.org/qemu-7.2.11.tar.xz
$ wget https://download.qemu.org/qemu-9.0.0.tar.xz
$ tar xvJf qemu-7.2.11.tar.xz
$ tar xvJf qemu-9.0.0.tar.xz

$ cd qemu-7.2.11
// or
$ cd qemu-9.0.0


// ARM, AARCH64, x86_64
$ ./configure --target-list="arm-softmmu,arm-linux-user,aarch64-linux-user,aarch64-softmmu,x86_64-softmmu,x86_64-linux-user"
$ make

// with enable GTK
$ sudo apt-get install libgtk-3-dev
$ ./configure --target-list="arm-softmmu,arm-linux-user,aarch64-linux-user,aarch64-softmmu,x86_64-softmmu,x86_64-linux-user" --enable-gtk
$ make


// path
$ ln -s $HOME/qemu-7.2.11/build/qemu-arm .
$ ln -s $HOME/qemu-7.2.11/build/qemu-aarch64 .
$ ln -s $HOME/qemu-7.2.11/build/qemu-system-arm .
$ ln -s $HOME/qemu-7.2.11/build/qemu-system-aarch64 .
// or
$ ln -s $HOME/qemu-9.0.0/build/qemu-arm .
$ ln -s $HOME/qemu-9.0.0/build/qemu-aarch64 .
$ ln -s $HOME/qemu-9.0.0/build/qemu-system-arm .
$ ln -s $HOME/qemu-9.0.0/build/qemu-system-aarch64 .
```


Build and Run
----------
```sh
1. Build

$ git clone https://github.com/godmode2k/simple-bootloader-test.git
$ cd simple-bootloader-test

$ arm-none-linux-gnueabihf-as -g -o startup.o startup.s
$ arm-none-linux-gnueabihf-gcc -g -Wall -Werror -O0 -Wl,--gc-sections -static -c -o bootloader2.o bootloader2.c
$ arm-none-linux-gnueabihf-ld -Map bootloader2.map -T bootloader2.ld -o bootloader2.elf startup.o bootloader2.o
$ arm-none-linux-gnueabihf-objdump -D bootloader2.elf > bootloader2.list
$ arm-none-linux-gnueabihf-objcopy bootloader2.elf bootloader2.bin
$ arm-none-linux-gnueabihf-size bootloader2.bin

or

$ sh build.sh


2. Run

$ qemu-system-arm -M versatilepb -cpu cortex-a15 -nographic -kernel bootloader2.bin

or

$ sh qemu_bootloader_test.sh

Bootloader! hello, wo1abc
Bootloader! hello, wo2
Bootloader! hello, wo3
Bootloader! hello, wo4
Bootloader! hello, wo5
Bootloader! hello, wo6
Bootloader! hello, wo7

Quit the QEMU: ctrl+a x
```


