#include "x86.h"

void outb(unsigned short port, unsigned char value)
{
	__asm__ __volatile__ ("out %%al, %%dx" : : "a" (value), "d" (port));
}

unsigned char inb(unsigned short port)
{
	unsigned char result;
	__asm__ __volatile__ ("in %%dx, %%al" : "=a" (result) : "d" (port));
	return result;
}