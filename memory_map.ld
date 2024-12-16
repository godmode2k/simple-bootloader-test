/* source-based: https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch */

/*
    0x0 +---------------------+
        |                     |
        |     Bootloader      |
        |                     |
 0x4000 +---------------------+
        |                     |
        |                     |
        |     Application     |
        |                     |
        |                     |
0x30000 +---------------------+
*/

/* memory_map.ld */
MEMORY
{
    bootrom  (rx)  : ORIGIN = 0x00000000, LENGTH = 0x00004000
    approm   (rx)  : ORIGIN = 0x00004000, LENGTH = 0x0003C000
    ram      (rwx) : ORIGIN = 0x20000000, LENGTH = 0x00008000
}

/*STACK_SIZE = 0x2000;*/
STACK_SIZE = DEFINED(STACK_SIZE) ? STACK_SIZE : DEFINED(__stack_size__) ? __stack_size__ : 0x2000;



__bootrom_start__ = ORIGIN(bootrom);
__bootrom_size__ = LENGTH(bootrom);
__approm_start__ = ORIGIN(approm);
__approm_size__ = LENGTH(approm);
