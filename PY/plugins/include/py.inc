/*
 *
 * AMX Mod X Module
 * Basic Genetic Algorithm Utilities
 * 
 * Codebase from Reusch, kenterfie@hlsw.de (AMXX 0.16, AMX 0.96)
 * Modification by Scrooge2029, 1641367382@qq.com (AMXX 1.82, AMXX 0.16)
 * 
 */

#pragma reqlib py
#if !defined AMXMODX_NOAUTOLOAD
	#pragma loadlib py
#endif

native init_py();

native get_var(str_len, type_str[], var_name[], &dst_int, &Float:dst_fl, dst_str[], Float:dst_vec[]);

native eval_py(py_cmd[]);

native set_var(type_str[], src_val_str[], dst_key_str[]);

native exit_py();

/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ ansicpg936\\ deff0{\\ fonttbl{\\ f0\\ fnil\\ fcharset134 Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang2052\\ f0\\ fs16 \n\\ par }
*/
