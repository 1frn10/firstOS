#include "string.h"

void memcpy(char* dest, char* src, int numBytes)
{
	for (int i = 0; i < numBytes; i++)
	{
		*(dest+i) = *(src+i);
	}
}