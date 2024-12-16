// source-based:
// - https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch
// - https://balau82.wordpress.com/2010/02/28/hello-world-for-bare-metal-arm-using-qemu/
// - https://www.youtube.com/watch?v=cfNJ85cX-ms
// - https://www.youtube.com/watch?v=3brOzLJmeek


/* boootloader.c */
#include <stdio.h>
#include <inttypes.h>
#include "memory_map.h"


/* Initialize segments */
extern uint32_t _stext;
extern uint32_t _etext;
extern uint32_t _sbss;
extern uint32_t _ebss;
extern uint32_t _sdata;
extern uint32_t _edata;
extern uint32_t _sstack;
extern uint32_t _estack;



// ARM PL011
// QEMU: UART0 is mapped: 0x101f1000
// https://github.com/qemu/qemu/blob/master/hw/arm/versatilepb.c
//
// https://developer.arm.com/documentation/ddi0139/b/programmer-s-model/register-descriptions/uartdr--8----0x00-?lang=en
// https://developer.arm.com/documentation/ddi0139/b/programmer-s-model/register-descriptions/uartfr--8----0x18-
//
// https://stackoverflow.com/questions/26243997/how-to-printout-string-in-qemu-gumstix-connex-pxa255-emulation
// The QEMU model of the PL011 serial port ignores the transmit FIFO capabilities;
// in a real system on chip the 'Transmit FIFO Full(TXFF)' flag must be checked 
// in the UARTFR register before writing on the UARTDR register.


// https://balau82.wordpress.com/2010/02/28/hello-world-for-bare-metal-arm-using-qemu/
volatile unsigned int* const UART0DR = (unsigned int*)0x101f1000;
static void print_uart0(const char* s) {
    while(*s != '\0') { /* Loop until end of string */
        *UART0DR = (unsigned int)(*s); /* Transmit char */
        s++; /* Next char */
    }
}

/*
#define UART0DR 0x101f1000
// r0: 0x101f1000, r1: char
void s_print_uart0(unsigned int, unsigned int);
static void _print_uart0(const char* s) {
    while ( *s != '\0' ) {
        //s_print_uart0( UART0DR, (unsigned int)(*s) );
        //s++;
        
        *((char*)UART0DR) = *s++;
    }
}
*/


#if 0
// https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch
static void __attribute__((naked)) start_app(uint32_t pc, uint32_t sp) {
#if 0
    __asm("\n\
            msr msp, r1 /* load r1 into MSP */\n\
            bx r0       /* branch to the address at r0 */\n\
    ");
#endif
/*
    __asm("\n\
            msr msp, r1 \n\
            bx r0       \n\
    ");
*/
    //__asm( "LDR r1, %0;" :: "m"(sp) );
    //__asm( "MOV sp, r1" );
    //__asm( "BL main" );

    __asm( "LDR sp, %0;" :: "m"(sp) );
    //__asm( "MOV sp, %0;" :: "r"(sp) );
    __asm( "BL main" );

}

int main(void) {
    //serial_init();
    //printf("Bootloader!\n");
    //serial_deinit();


    uint32_t *app_code = (uint32_t *)__approm_start__;
    uint32_t app_sp = app_code[0];
    uint32_t app_start = app_code[1];

    // set SP, Reset_Handler
    start_app(app_start, app_sp);

    // should never be reached
    while (1);
}
#endif


#if 0
// https://www.youtube.com/watch?v=cfNJ85cX-ms
static void jump_to_main(void) {
    typedef void (*fnptr)(void);
    uint32_t* reset_vector_entry = (uint32_t*)(__approm_start__ + 4U);
    uint32_t* reset_vector = (uint32_t*)(*reset_vector_entry);
    fnptr func = (fnptr)reset_vector;
    func();
}
void main(void) {
    jump_to_main();

    // should never be reached
    while (1);
}
#endif


void boot_main(void) {
    print_uart0( "Bootloader! hello, wo1abc\n" );
    print_uart0( "Bootloader! hello, wo2\n" );
    print_uart0( "Bootloader! hello, wo3\n" );
    print_uart0( "Bootloader! hello, wo4\n" );
    print_uart0( "Bootloader! hello, wo5\n" );
    print_uart0( "Bootloader! hello, wo6\n" );
    print_uart0( "Bootloader! hello, wo7\n" );
    //_print_uart0( "Bootloader!\n" );


    // should never be reached
    //while (1);
}
