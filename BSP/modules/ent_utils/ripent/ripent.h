﻿#include "cmdlib.h"
#include "messages.h"
#include "win32fix.h"
#include "log.h"
#include "hlassert.h"
#include "mathlib.h"
#include "scriplib.h"
#include "winding.h"
#include "threads.h"
#include "bspfile.h"
#include "blockmem.h"
#include "filelib.h"
#ifdef ZHLT_PARAMFILE
#include "cmdlinecfg.h"
#endif

#include <string>
#include <vector>
using namespace std;


#define DEFAULT_PARSE false
#ifdef RIPENT_TEXTURE
#define DEFAULT_TEXTUREPARSE false
#endif
#define DEFAULT_CHART false
#define DEFAULT_INFO true
#ifdef ZHLT_64BIT_FIX
#define DEFAULT_WRITEEXTENTFILE false
#endif
#ifdef ZHLT_EMBEDLIGHTMAP
#ifdef RIPENT_TEXTURE
#define DEFAULT_DELETEEMBEDDEDLIGHTMAPS false
#endif
#endif

#ifdef RIPENT_PAUSE
#ifdef SYSTEM_WIN32
#undef cscanf
#undef cprintf
#include <conio.h>
#endif
#endif
#ifdef ZHLT_LANGFILE
#ifdef SYSTEM_WIN32
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#endif
#endif


extern int main_ripent_read(string map_name);