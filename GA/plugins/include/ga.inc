/*
 *
 * AMX Mod X Module
 * Basic Genetic Algorithm Utilities
 * 
 * Codebase from Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by Scrooge2029, 1641367382@qq.com (AMXX 1.82, AMXX 0.16)
 * 
 */

#pragma reqlib ga
#if !defined AMXMODX_NOAUTOLOAD
	#pragma loadlib ga
#endif

native init_task(_population, Float:_x, Float:_y, Float:_z, Float:_w);

native test_ga(&_x, &_y, &_z, &_w);
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
