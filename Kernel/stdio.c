#include "stdio.h"
#include "x86.h"
#include "string.h"

int get_cur_pos_from_colrow(int col, int row)
{
	return (row * 80 + col) * 2;
}

int get_row_from_cursor_pos(int cursor_pos)
{
	return cursor_pos / (80 * 2);
}

int move_to_newline(int cursor_pos)
{
	return get_cur_pos_from_colrow(0, get_row_from_cursor_pos(cursor_pos) + 1);
}

void set_cursor_position(int mem_offset)
{
	mem_offset /= 2;
	outb(VGA_CTRL_PORT, 14);
	outb(VGA_DATA_PORT, (unsigned char)(mem_offset >> 8));
	outb(VGA_CTRL_PORT, 15);
	outb(VGA_DATA_PORT, (unsigned char)(mem_offset & 0xFF));
}

int get_cursor_position()
{
	int result;
	outb(VGA_CTRL_PORT, 14);
	result = inb(VGA_DATA_PORT) << 8;
	outb(VGA_CTRL_PORT, 15);
	result += inb(VGA_DATA_PORT);
	return result * 2;
}

void put_char(char c, int offset)
{
	unsigned char* videomem = (unsigned char*)VGA_TEXT_START;
	videomem[offset] = c; 
	videomem[offset+1] = 0x0f;
}

void print_string(char* string)
{
	
	int cursor_pos = get_cursor_position();
	int i = 0;
	while(string[i] != 0)
	{
		if (cursor_pos >= 80 * 25 * 2)
		{
			cursor_pos = scroll_back(cursor_pos);
		}
		if (string[i] == '\n')
		{
			cursor_pos = handle_newline(cursor_pos);
		}
		else
		{
			put_char(string[i], cursor_pos);
			cursor_pos += 2;	
		}
		i++;
	}

	set_cursor_position(cursor_pos);
}

int handle_newline(int cursor_pos)
{
	int new_pos = move_to_newline(cursor_pos);
	if (new_pos >= 80 * 25 * 2)
		new_pos = scroll_back(new_pos);
	set_cursor_position(new_pos);
	return new_pos;
}


int scroll_back(int cursor_pos)
{
	memcpy((char*)(get_cur_pos_from_colrow(0, 0) + VGA_TEXT_START),
		   (char*)(get_cur_pos_from_colrow(0, 1) + VGA_TEXT_START),
		   80 * 24 * 2);

	for (int i = 0; i < 80; i++)
	{
		put_char(' ', get_cur_pos_from_colrow(i, 24));
	}

	return cursor_pos - (80 * 2);
}

void clear_screen(void)
{
	int size = 80 * 25;
	for (int i = 0; i < size; i++)
	{
		put_char(' ', i * 2);
	}

	set_cursor_position(0);
}