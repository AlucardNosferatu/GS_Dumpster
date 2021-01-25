#if defined _ExecuteX_included
	#endinput
#endif

#define _ExecuteX_included



/* Starts an executable application.
* 
* Basicly a wrapper for ShellExecuteEx().
* This means you can use this for .exe's just aswell as for .doc's or .mp3's.
* 
* file[] (constant)
* 	Filepath and filename, this does not start from moddir.
* 	Example:
* 		"C:\Program Files\Anti-Virus Update.exe"
* 
* [params[] (constant)]
* 	Parameters ( duh )
* 
* 
* 
* Return:
* 	Returns ProcessID on success.
* 	If the file was a non-executable, associated file 1 would be returned on success
* 
* 	Otherwise 0 is returned and an errormessage
* 
*/
native Execute(const file[], const params[] = "");
