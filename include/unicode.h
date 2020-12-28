#ifndef _NAVIDOC_UNICODE_H
#define _NAVIDOC_UNICODE_H
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>

// utf-8 says it can use 6 byte codepoints
// unicode does not really like using more than 4 though
#define UTF8_MAX_SIZE 4
#define UTF8_INVALID 0x80

/**
 * takes the next utf-8 char and advance the string pointer
 */
uint32_t utf8_decode(const char **str);

/**
 * encode a char as utf-8 and returns the length of new encoded char
 */
size_t utf8_encode(char *str, uint32_t ch);

/**
 * returns the size of the next utf-8 char
 */
int utf8_size(const char *str);

/**
 * returns the size of a utf-8 char
 */
size_t utf8_chsize(uint32_t ch);

/**
 * reads and returns the next char from the file
 */
uint32_t utf8_fgetch(FILE *f);

/**
 * writes this char to the file and returns the number of bytes written
 */
size_t utf8_fputch(FILE *f, uint32_t ch);

#endif
