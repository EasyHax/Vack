module process

#include "TlHelp32.h"
__global g_proc Process
struct C.tagPROCESSENTRY32W {
	dwSize              u64
	cntUsage            u64
	th32ProcessID       u64
	th32DefaultHeapID   voidptr
	th32ModuleID        u64
	cntThreads          u64
	th32ParentProcessID u64
	pcPriClassBase      i64
	dwFlags             u64
	szExeFile           charptr
}

struct C.tagMODULEENTRY32W {
	dwSize        u64
	th32ModuleID  u64
	th32ProcessID u64
	GlblcntUsage  u64
	ProccntUsage  u64
	modBaseAddr   byteptr
	modBaseSize   u64
	hModule       voidptr
	szModule      charptr
	szExePath     charptr
}

fn C.OpenProcess(arg_1, arg_2 int, arg_3 u64) int
fn C.CreateToolhelp32Snapshot(arg_1, arg_2 int) voidptr

fn C.Process32First(arg_1, arg_2 voidptr) int
fn C.Process32Next (arg_1, arg_2 voidptr) int

fn C.Module32First(arg_1, arg_2 voidptr) int
fn C.Module32Next (arg_1, arg_2 voidptr) int

fn C.mouse_event(arg_1, arg_2, arg_3, arg_4 u64, arg_5 voidptr)

pub struct Module {
pub:
	base   int
	size   int
	handle int
}

pub struct Process {
pub mut:
	pid     u64
	handle  int
	modules map[string]Module
}

pub fn find_pid(process_name string) u64 {
	pe32 := C.tagPROCESSENTRY32W{
		dwSize: sizeof(C.tagPROCESSENTRY32W)
	}
	th32 := C.CreateToolhelp32Snapshot(C.TH32CS_SNAPPROCESS, 0)
	if th32 == -1 || C.Process32First(th32, &pe32) == 0 {
		panic('tlhelp32 error')
	}
	for C.Process32Next(th32, &pe32) != 0 {
		mut chars := []byte{}
		p_str := pe32.szExeFile
		for i := 0; byte(*byteptr(int(p_str) + i)) != 0; i += 2 {
			chars << byte(*byteptr(int(p_str) + i))
		}
		if string(chars).contains(process_name) {
			C.CloseHandle(th32)
			return pe32.th32ProcessID
		}
	}
	panic('$process_name is not running')
}

pub fn get_module_info(pid u64, module_name string) Module {
	me32 := C.tagMODULEENTRY32W{
		dwSize: sizeof(C.tagMODULEENTRY32W)
	}
	th32 := C.CreateToolhelp32Snapshot(C.TH32CS_SNAPMODULE, pid)
	if th32 == -1 || C.Module32First(th32, &me32) == 0 {
		panic('tlhelp32 error')
	}
	for C.Module32Next(th32, &me32) != 0 {
		mut chars := []byte{}
		p_str := me32.szModule
		for i := 0; byte(*byteptr(int(p_str) + i)) != 0; i += 2 {
			chars << byte(*byteptr(int(p_str) + i))
		}
		mod_name := string(chars)
		if mod_name.starts_with(module_name) {
			C.CloseHandle(th32)
			return Module{
				base: int(me32.modBaseAddr)
				size: int(me32.modBaseSize)
				handle: int(me32.hModule)
			}
		}
	}
	panic('Unable to find $module_name base address')
}

fn load_modules(pid u64) map[string]Module {
	mut mods := map[string]Module{}
	me32 := C.tagMODULEENTRY32W{
		dwSize: sizeof(C.tagMODULEENTRY32W)
	}
	th32 := C.CreateToolhelp32Snapshot(C.TH32CS_SNAPMODULE, pid)
	if th32 == -1 || C.Module32First(th32, &me32) == 0 {
		panic('tlhelp32 error')
	}
	for C.Module32Next(th32, &me32) != 0 {
		mut chars := []byte{}
		p_str := me32.szModule
		for i := 0; byte(*byteptr(int(p_str) + i)) != 0; i += 2 {
			chars << byte(*byteptr(int(p_str) + i))
		}
		mod_name := string(chars)
		if !mod_name.ends_with('.dll') {
			continue
		}
		mods[mod_name] = Module{
			base: int(me32.modBaseAddr)
			size: int(me32.modBaseSize)
			handle: int(me32.hModule)
		}
		// mods[mod_name] = int( me32.modBaseAddr )
	}
	C.CloseHandle(th32)
	return mods
}

pub fn attach(process_name string) {
	g_proc = Process{}
	g_proc.pid = find_pid(process_name)
	g_proc.handle = C.OpenProcess(C.PROCESS_ALL_ACCESS, 0, g_proc.pid)
	g_proc.modules['engine.dll'      ] = get_module_info(g_proc.pid, 'engine.dll'      )
	g_proc.modules['client.dll'      ] = get_module_info(g_proc.pid, 'client.dll'      )
	g_proc.modules['vstdlib.dll'     ] = get_module_info(g_proc.pid, 'vstdlib.dll'     )
	g_proc.modules['shaderapidx9.dll'] = get_module_info(g_proc.pid, 'shaderapidx9.dll')
}

pub fn left_click() {
	C.mouse_event(MouseEventFlags.leftdown, 0, 0, 0, 0)
	C.Sleep(1)
	C.mouse_event(MouseEventFlags.leftup, 0, 0, 0, 0)
}

enum MouseEventFlags {
	leftdown   = 0x00000002
	leftup     = 0x00000004
	middledown = 0x00000020
	middleup   = 0x00000040
	move       = 0x00000001
	absolute   = 0x00008000
	rightdown  = 0x00000008
	rightup    = 0x00000010
	wheel      = 0x00000800
	xdown      = 0x00000080
	xup        = 0x00000100
}
