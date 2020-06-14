module csgo

import memory
import math

__global g_csgo Csgo

pub struct Csgo {
pub mut:
	localplayer Player
}

// ##############################################
pub fn (csgo Csgo) client() int {
	return g_proc.modules['client.dll'].base
}

pub fn (csgo Csgo) engine() int {
	return g_proc.modules['engine.dll'].base
}

pub fn (csgo Csgo) clientstate() int {
	return memory.read<int>(csgo.engine() + g_sgn['dwClientState'])
}

pub fn (csgo Csgo) entity_list() int {
	return csgo.client() + g_sgn['dwEntityList']
}

pub fn (csgo Csgo) glow() int {
	return memory.read<int>(csgo.client() + g_sgn['dwGlowObjectManager'])
}

pub fn (csgo Csgo) max_players() int {
	return memory.read<int>(csgo.clientstate() + g_sgn['dwClientState_MaxPlayer'])
}

pub fn (csgo Csgo) localplayer() Player {
	return Player{memory.read<int>(csgo.client() + g_sgn['dwLocalPlayer'])}
}

pub fn (csgo Csgo) player_by_index(index int) Player {
	return Player{memory.read<int>(csgo.entity_list() + 0x10 * index)}
}

pub fn (csgo Csgo) get_view_angles() Vector {
	return memory.read<Vector>(csgo.clientstate() + g_sgn['dwClientState_ViewAngles'])
}

pub fn (csgo Csgo) set_view_angles(vec_angles Vector) {
	memory.write<Vector>(csgo.clientstate() + g_sgn['dwClientState_ViewAngles'], vec_angles)
}

pub fn (csgo Csgo) get_enemies_from(players []Player) []Player {
	mut enemies := []Player{}

	for player in players {
		if player.is_enemy() {
			enemies << player
		}
	}
	return enemies
}

pub fn (csgo Csgo) get_enemies() []Player {
	mut players := []Player{}

	for i in 0 .. csgo.max_players() {
		player := csgo.player_by_index(i)
		if player.is_alive() && player.is_enemy() {
			players << player
		}
	}
	return players
}

pub fn (csgo Csgo) get_players() []Player {
	mut players := []Player{}

	for i in 0 .. csgo.max_players() {
		player := csgo.player_by_index(i)
		if player.is_alive() {
			players << player
		}
	}
	return players
}

// ##############################################
pub fn (p Player) health() int {
	return memory.read<int>(p.addr + g_ntv.m_ihealth)
}

pub fn (p Player) is_alive() bool {
	return p.health() > 0
}

pub fn (p Player) is_spotted() bool {
	return memory.read<int>(p.addr + g_ntv.m_bspottedbymask) != 0
}

pub fn (p Player) team() int {
	return memory.read<int>(p.addr + g_ntv.m_iteamnum)
}

pub fn (p Player) glow_id() int {
	return memory.read<int>(p.addr + g_ntv.m_iglowindex)
}

pub fn (p Player) get_glow() Glow_t {
	return memory.read<Glow_t>(g_csgo.glow() + p.glow_id() * 0x38)
}

pub fn (p Player) set_glow(glow_t Glow_t) {
	memory.write<Glow_t>(g_csgo.glow() + p.glow_id() * 0x38, glow_t)
}

pub fn (p Player) dormant() bool {
	return memory.read<int>(p.addr + g_sgn['m_bDormant']) == 1
}

pub fn (p Player) is_enemy() bool {
	return p.team() != g_csgo.localplayer.team()
}

pub fn (p Player) aimpunch() Vector {
	return memory.read<Vector>(p.addr + g_ntv.m_aimpunchangle) * Vector{2, 2, 2}
}

pub fn (p Player) eyepos() Vector {
	pos := p.pos()
	return Vector{
		x: pos.x
		y: pos.y
		z: pos.z + p.viewof().z
	}
}

pub fn (p Player) pos() Vector {
	return memory.read<Vector>(p.addr + g_ntv.m_vecorigin)
}

pub fn (p Player) viewof() Vector {
	return memory.read<Vector>(p.addr + g_ntv.m_vecviewoffset)
}

pub fn (p Player) bone_matrix() int {
	return memory.read<int>(p.addr + g_ntv.m_dwbonematrix)
}

pub fn (p Player) crosshair_id() int {
	return memory.read<int>(p.addr + g_ntv.m_icrosshairid) - 1
}

pub fn (p Player) bone_pos(bone Bone) Vector {
	bone_matrix := p.bone_matrix() + 0x30 * int(bone) + 0x0C

	return Vector{
		x: memory.read<f32>(bone_matrix + 0x00)
		y: memory.read<f32>(bone_matrix + 0x10)
		z: memory.read<f32>(bone_matrix + 0x20)
	}
}

pub struct Player {
pub:
	addr int
}

// ##############################################
pub fn (v1 Vector) angle_with(v2 Vector) Vector {
	diff := v1 - v2
	dist := diff.magnitude()

	mut vec := Vector{
		x: f32(math.asin(diff.z / dist) * (180 / math.pi))
		y: f32(math.atan(diff.y / diff.x) * (180 / math.pi))
		z: f32(0)
	}

	vec.y = if diff.x > 0  { vec.y + 180 } else { vec.y }
	vec.y = if vec.y > 180 { vec.y - 360 } else { vec.y }

	return vec
}

pub fn (to Vector) smooth_from(from Vector, s f32) Vector {
	vec_smooth := Vector{s, s, s}
	return (to - from) / vec_smooth + from
}

pub fn (mut v Vector) clamp() {
	if v.x > 89.0 && v.x <= 180.0 {
		v.x = 89.0
	}
	for v.x > 180 {
		v.x -= 360
	}
	for v.x < -89.0 {
		v.x = -89.0
	}
	for v.y > 180 {
		v.y -= 360
	}
	for v.y < -180 {
		v.y += 360
	}
	v.z = 0
}

pub fn (v1 Vector) fov_with(v2 Vector) f64 {
	return (v1 - v2).magnitude()
}

pub fn (mut v Vector) abs() {
	v.x = f32(math.abs(v.x))
	v.y = f32(math.abs(v.y))
	v.z = f32(math.abs(v.z))
}

pub fn (v Vector) magnitude() f32 {
	return math.sqrtf(math.powf(v.x, 2) + math.powf(v.y, 2) + math.powf(v.z, 2))
}

fn (v2 Vector) +(v1 Vector) Vector {
	return Vector{v2.x + v1.x, v2.y + v1.y, v2.z + v1.z}
}

fn (v2 Vector) -(v1 Vector) Vector {
	return Vector{v2.x - v1.x, v2.y - v1.y, v2.z - v1.z}
}

fn (v2 Vector) *(v1 Vector) Vector {
	return Vector{v2.x * v1.x, v2.y * v1.y, v2.z * v1.z}
}

fn (v2 Vector) /(v1 Vector) Vector {
	return Vector{v2.x / v1.x, v2.y / v1.y, v2.z / v1.z}
}

pub struct Vector {
pub mut:
	x f32
	y f32
	z f32
}

// ##############################################

pub struct Glow_t {
pub mut:
	pad0            [4]byte
	r               f32
	g               f32
	b               f32
	a               f32
	pad1            [16]byte
	when_occluded   bool
	when_unoccluded bool
	full_bloom      bool
}

pub enum Bone {
	head       = 8
	body       = 6
	right_hand = 39
	left_hand  = 13
	right_leg  = 73
	left_leg   = 66
	right_foot = 74
	left_foot  = 67
}
