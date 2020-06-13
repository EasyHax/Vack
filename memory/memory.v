module memory

import offset

fn init() int {
    modules_buffer = map[string][]byte
    return 1
}

__global g_mem Memory

fn C.ReadProcessMemory ( int, int, voidptr, int, voidptr ) int
fn C.WriteProcessMemory( int, int, voidptr, int, voidptr ) int

fn C.GetAsyncKeyState( Vkey ) int

pub struct Memory {
	pub:
	handle int
}

pub fn read<T>( addr int ) T {
	unsafe {
		mut data := T{}
		C.ReadProcessMemory( g_mem.handle, addr, &data, sizeof(T), 0 )
		return data
	}
}

pub fn read_array( addr int, count int ) []byte {
	unsafe {

        ptr := malloc( count )

        C.ReadProcessMemory( g_mem.handle, addr, ptr, count, 0 )

        // temp hack
        mut data := []byte{}
        for i in 0 .. count {
            unsafe {
                data << *byteptr( ( int(ptr) + i ) )
            }
        }

        /*
        data := []byte{ len: count, init: 0 }
        C.ReadProcessMemory( g_mem.handle, addr, &data, count, 0 )
        */

		return data
	}
}

/* pub fn read_array<T>( addr, count int ) []T {
	unsafe {
		mut data := [count]T{}
		C.ReadProcessMemory( g_mem.handle, addr, &data, sizeof(T) * count, 0 )
		return data
	}
} */

pub fn write<T>( addr int, data T ) {
	unsafe {
		C.WriteProcessMemory( g_mem.handle, addr, &data, sizeof(T), 0 )
	}
}

/* pub fn write_array<T>( addr int, arr []T ) {
	unsafe {
		C.WriteProcessMemory( g_mem.handle, addr, &data, sizeof(T) * arr.len, 0 )
	}
} */

pub fn is_key_down( vkey Vkey ) bool {
	key_state := C.GetAsyncKeyState( vkey )
	return key_state == 0x8000 || key_state == -0x8000
}

//##############################################

__global modules_buffer map[string][]byte

pub fn ( m Memory ) sig_scan( sig offset.Sig ) int {

    mut buffer := []byte{}
    mod := g_proc.modules[sig.mod_name]

    if mod.handle == 0 { return -1 }

    if modules_buffer[sig.mod_name].len == 0 {

        //buffer = memory.read_array<byte>( mod.base, mod.size )
        buffer = memory.read_array( mod.base, mod.size )
        modules_buffer[sig.mod_name] = buffer

    } else { buffer = modules_buffer[sig.mod_name] }

    mut addr := m.scan_pattern_from_buffer( buffer, sig.pattern )

    if addr == -1 { return addr }

    if sig.offsets.len != 0 {
        addr = memory.read<int>( addr + mod.base + sig.offset() ) + sig.extra
        addr = if sig.relative { addr - mod.base } else { addr }
    }
    else { addr += sig.extra }

    return addr
}

pub fn ( m Memory ) scan_pattern_from_buffer( buffer []byte, signature string ) int {
    s := signature.split(' ')
    mut p := []int{}

    for i in 0 .. s.len {
        if s[i].contains( '?' ) {
            p << -1
        } else {
            b := '0x' + s[i]
            p << b.int()
        }
    }

    for i in 0 .. buffer.len - s.len {
        for j in 0 .. s.len {
            if buffer[i + j] != p[j] && p[j] != -1 {
                break
            }
            if j == s.len - 1 {
                return i
            }
        }
    }

    return -1
}

//##############################################

pub enum Vkey
{
	leftbutton         = 0x01
    rightbutton        = 0x02
    cancel             = 0x03
    middlebutton       = 0x04
    extrabutton1       = 0x05
    extrabutton2       = 0x06
    back               = 0x08
    tab                = 0x09
    clear              = 0x0c
    ret                = 0x0d
    shift              = 0x10
    control            = 0x11
    menu               = 0x12
    pause              = 0x13
    capslock           = 0x14
    kana               = 0x15
    hangeul            = 0x15
    hangul             = 0x15
    junja              = 0x17
    final              = 0x18
    hanja              = 0x19
    kanji              = 0x19
    escape             = 0x1b
    convert            = 0x1c
    nonconvert         = 0x1d
    accept             = 0x1e
    modechange         = 0x1f
    space              = 0x20
    prior              = 0x21
    next               = 0x22
    end                = 0x23
    home               = 0x24
    left               = 0x25
    up                 = 0x26
    right              = 0x27
    down               = 0x28
    sel                = 0x29
    print              = 0x2a
    execute            = 0x2b
    snapshot           = 0x2c
    insert             = 0x2d
    delete             = 0x2e
    help               = 0x2f
    n0                 = 0x30
    n1                 = 0x31
    n2                 = 0x32
    n3                 = 0x33
    n4                 = 0x34
    n5                 = 0x35
    n6                 = 0x36
    n7                 = 0x37
    n8                 = 0x38
    n9                 = 0x39
    a                  = 0x41
    b                  = 0x42
    c                  = 0x43
    d                  = 0x44
    e                  = 0x45
    f                  = 0x46
    g                  = 0x47
    h                  = 0x48
    i                  = 0x49
    j                  = 0x4a
    k                  = 0x4b
    l                  = 0x4c
    m                  = 0x4d
    n                  = 0x4e
    o                  = 0x4f
    p                  = 0x50
    q                  = 0x51
    r                  = 0x52
    s                  = 0x53
    t                  = 0x54
    u                  = 0x55
    v                  = 0x56
    w                  = 0x57
    x                  = 0x58
    y                  = 0x59
    z                  = 0x5a
    leftwindows        = 0x5b
    rightwindows       = 0x5c
    application        = 0x5d
    sleep              = 0x5f
    numpad0            = 0x60
    numpad1            = 0x61
    numpad2            = 0x62
    numpad3            = 0x63
    numpad4            = 0x64
    numpad5            = 0x65
    numpad6            = 0x66
    numpad7            = 0x67
    numpad8            = 0x68
    numpad9            = 0x69
    multiply           = 0x6a
    add                = 0x6b
    separator          = 0x6c
    subtract           = 0x6d
    decimal            = 0x6e
    divide             = 0x6f
    f1                 = 0x70
    f2                 = 0x71
    f3                 = 0x72
    f4                 = 0x73
    f5                 = 0x74
    f6                 = 0x75
    f7                 = 0x76
    f8                 = 0x77
    f9                 = 0x78
    f10                = 0x79
    f11                = 0x7a
    f12                = 0x7b
    f13                = 0x7c
    f14                = 0x7d
    f15                = 0x7e
    f16                = 0x7f
    f17                = 0x80
    f18                = 0x81
    f19                = 0x82
    f20                = 0x83
    f21                = 0x84
    f22                = 0x85
    f23                = 0x86
    f24                = 0x87
    numlock            = 0x90
    scrolllock         = 0x91
    nec_equal          = 0x92
    fujitsu_jisho      = 0x92
    fujitsu_masshou    = 0x93
    fujitsu_touroku    = 0x94
    fujitsu_loya       = 0x95
    fujitsu_roya       = 0x96
    leftshift          = 0xa0
    rightshift         = 0xa1
    leftcontrol        = 0xa2
    rightcontrol       = 0xa3
    leftmenu           = 0xa4
    rightmenu          = 0xa5
    browserback        = 0xa6
    browserforward     = 0xa7
    browserrefresh     = 0xa8
    browserstop        = 0xa9
    browsersearch      = 0xaa
    browserfavorites   = 0xab
    browserhome        = 0xac
    volumemute         = 0xad
    volumedown         = 0xae
    volumeup           = 0xaf
    medianexttrack     = 0xb0
    mediaprevtrack     = 0xb1
    mediastop          = 0xb2
    mediaplaypause     = 0xb3
    launchmail         = 0xb4
    launchmediaselect  = 0xb5
    launchapplication1 = 0xb6
    launchapplication2 = 0xb7
    oem1               = 0xba
    oemplus            = 0xbb
    oemcomma           = 0xbc
    oemminus           = 0xbd
    oemperiod          = 0xbe
    oem2               = 0xbf
    oem3               = 0xc0
    oem4               = 0xdb
    oem5               = 0xdc
    oem6               = 0xdd
    oem7               = 0xde
    oem8               = 0xdf
    oemax              = 0xe1
    oem102             = 0xe2
    icohelp            = 0xe3
    ico00              = 0xe4
    processkey         = 0xe5
    icoclear           = 0xe6
    packet             = 0xe7
    oemreset           = 0xe9
    oemjump            = 0xea
    oempa1             = 0xeb
    oempa2             = 0xec
    oempa3             = 0xed
    oemwsctrl          = 0xee
    oemcusel           = 0xef
    oemattn            = 0xf0
    oemfinish          = 0xf1
    oemcopy            = 0xf2
    oemauto            = 0xf3
    oemenlw            = 0xf4
    oembacktab         = 0xf5
    attn               = 0xf6
    crsel              = 0xf7
    exsel              = 0xf8
    ereof              = 0xf9
    play               = 0xfa
    zoom               = 0xfb
    noname             = 0xfc
    pa1                = 0xfd
    oemclear           = 0xfe
}