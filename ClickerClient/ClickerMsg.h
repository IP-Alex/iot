#ifndef CLICKER_MSG_H
#define CLICKER_MSG_H

/* Define the constant AM_CLICKER_MSG to be 42, the active
 * message type of our application. */
enum { AM_CLICKER_MSG = 43 };

/* Structure of the payload. Our payload has just one field,
 * which is a four byte array. */
nx_struct ClickerMsg_s {
	nx_uint8_t string[4];
};

/* For convenience, we assign the name ClickerMsg to our payload
 * struct. */
typedef nx_struct ClickerMsg_s ClickerMsg;

#endif
