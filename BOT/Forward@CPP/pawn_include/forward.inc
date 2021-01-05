/*
 *
 * AMX Mod X Module
 * Basic ANN Forward Utilities
 * 
 * Codebase from Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by Scrooge2029, 1641367382@qq.com (AMXX 1.82, AMXX 0.16)
 * 
 */

#if defined _socket_included
	#endinput
#endif
#define _socket_included


#pragma reqlib forward
#if !defined AMXMODX_NOAUTOLOAD
	#pragma loadlib forward
#endif

native test_forward(const _hostname[], _port, _protocol = 1, &_error);

native load_model(const ini_path[]);

native forward_model(&out_class, out_dims, slice_length, total_length, flatten_input[]);
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
