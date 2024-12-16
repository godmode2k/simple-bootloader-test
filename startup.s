.global _start
_start:
    /*LDR sp, =STACK_SIZE */

    LDR sp, =_end
    /*LDR sp, =stack_top*/

    BL boot_main
    B .



// QEMU: UART0 is mapped: 0x101f1000
// https://github.com/qemu/qemu/blob/master/hw/arm/versatilepb.c
.global s_print_uart0
s_print_uart0:
    STR r1, [r0]
    BX lr


