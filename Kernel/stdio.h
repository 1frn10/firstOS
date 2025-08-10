#pragma once

#define VGA_TEXT_START 0xb8000
#define VGA_CTRL_PORT 0x3d4
#define VGA_DATA_PORT 0x3d5


void put_char(char c, int offset);
void set_cursor_position(int mem_offset);

int get_cursor_position(void);

void print_string(char* string);
void clear_screen(void);
int handle_newline(int cursor_pos);
int scroll_back(int cursor_pos);