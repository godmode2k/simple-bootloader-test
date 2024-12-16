/* source-based: https://interrupt.memfault.com/blog/how-to-write-a-bootloader-from-scratch */

/* memory_map.h */
#pragma once

extern int __bootrom_start__;
extern int __bootrom_size__;
extern int __approm_start__;
extern int __approm_size__;
