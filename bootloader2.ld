/* source-based: https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch */

/*
OUTPUT_FORMAT("elf32-littlearm", "elf32-littlearm", "elf32-littlearm")
OUTPUT_ARCH(arm)
*/



/*INCLUDE memory_map.ld*/

MEMORY
{
    bootrom  (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00004000
}
STACK_SIZE = 0x2000;
/*STACK_SIZE = DEFINED(STACK_SIZE) ? STACK_SIZE : DEFINED(__stack_size__) ? __stack_size__ : 0x2000;*/



/* Section Definitions */
ENTRY(_start)
SECTIONS
{
    .text :
    {
        KEEP(*(.vectors .vectors.*))
        *(.text*)
        *(.rodata*)
        _etext = . ;
    } > bootrom

    /* .bss section which is used for uninitialized data */
    .bss (NOLOAD) :
    {
        _sbss = . ;
        *(.bss*)
        *(COMMON)
        _ebss = . ;
    } > bootrom

    .data :
    {
        _sdata = . ;
        *(.data*);
        _edata = . ;
    } > bootrom

    /* stack section */
    .stack (NOLOAD) :
    {
        . = ALIGN(8);
        _sstack = . ;
        . = . + STACK_SIZE;
        . = ALIGN(8);
        _estack = . ;
    } > bootrom

    . = ALIGN(4);
    _end = . ;



/* stack size: 4k */
/* https://balau82.wordpress.com/2010/02/28/hello-world-for-bare-metal-arm-using-qemu/ */
/*
    . = 0x10000;
    .startup . : { startup.o(.text) }
    .text : { *(.text) }
    .data : { *(.data) }
    .bss : { *(.bss COMMON) }
    . = ALIGN(8);
    . = . + 0x1000;
    stack_top = .;
*/
}
