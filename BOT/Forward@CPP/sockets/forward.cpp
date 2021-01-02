/*
 *
 * AMX Mod X Module
 * Basic ANN Forward Utilities
 *
 * Codebase from Ivan, -g-s-ivan@web.de (AMX 0.9.3)
 * Modification by Olaf Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by David Anderson, dvander@tcwonline.org (AMXx 0.20)
 *
 * Bugs/Fixes
 *
 * v0.1
 * - code structure renewed
 * v0.2
 * - added socket_send2 to send data containing null bytes (FALUCO)(AMXX v1.65)
 */

#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

 /* Windows */
#include <winsock.h>
#include <io.h>
#define socklen_t int


// AMX Headers
#include "amxxmodule.h"


// native socket_open(_hostname[], _port, _protocol = SOCKET_TCP, &_error);
static cell AMX_NATIVE_CALL socket_open(AMX* amx, cell* params)  /* 2 param */
{
	unsigned int port = params[2];
	int len;
	char* hostname = MF_GetAmxString(amx, params[1], 0, &len); // Get the hostname from AMX
	cell* err = MF_GetAmxAddr(amx, params[4]);
	int sock = params[3] + params[2];
	*err = sock; // params[4] is error backchannel
	return sock * 2;
}

AMX_NATIVE_INFO sockets_natives[] = {
	{"socket_open", socket_open},
	{NULL, NULL}
};

void OnAmxxAttach()
{
	return;
}

void OnAmxxDetach()
{
	return;
}
