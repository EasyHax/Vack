module main

import memory
import process
import offset
import csgo
import os
import json

// #include <pthread.h>
fn C.pthread_create(arg_1, arg_2, arg_3, arg_4 voidptr)
fn C.pthread_join(arg_1, arg_2 voidptr)

__global nullptr voidptr = voidptr(0)
// ##############################################
fn wallhack(players []csgo.Player) {

	for player in players {
		if player.dormant() { continue }

		mut glow_t := player.get_glow()
		health := f32(player.health())

		if player.is_enemy() {
			glow_t.r = f32(1 - health / 100)
			glow_t.g = f32(health / 100)
			glow_t.b = f32(0)
		} else {
			glow_t.r = f32(0.3)
			glow_t.g = f32(health / 100)
			glow_t.b = f32(1)
		}
		glow_t.a = f32(1)
		glow_t.when_occluded   = true
		glow_t.when_unoccluded = false
		glow_t.full_bloom      = false
		
		player.set_glow(glow_t)
		C.Sleep(1)
	}
}

// ##############################################
fn triggerbot(trigger Triggerbot) {
	if !memory.is_key_down(trigger.key) {
		return
	}

	id := g_csgo.localplayer.crosshair_id()
	en := g_csgo.player_by_index(id)

	if en.is_alive() && en.is_enemy() {
		C.Sleep(trigger.delay)
		process.left_click()
	}
}

// ##############################################
fn aimbot(players []csgo.Player, aimbot Aimbot) {
	if !memory.is_key_down(aimbot.key) {
		return
	}

	vec_view := g_csgo.get_view_angles()
	aimpunch := g_csgo.localplayer.aimpunch()
	aim_from := g_csgo.localplayer.eyepos()

	mut fovs := []f64{}
	mut vecs := []csgo.Vector{}

	for player in players {
		if !player.is_spotted() { continue }

		aim_to := player.bone_pos(aimbot.bone)
		mut angle := aim_from.angle_with(aim_to)
		en_fov := (vec_view + aimpunch).fov_with(angle)
		
		if en_fov < aimbot.fov {
			fovs << en_fov
			vecs << angle
		}
	}

	mut best_fov_index := 0
	mut best_fov := f64(999)

	for i, fov in fovs {
		if fov < best_fov {
			best_fov = fov
			best_fov_index = i
		}
	}
	if best_fov != 999 {
		mut angle := vecs[best_fov_index] - aimpunch
		mut angle = angle.smooth_from(vec_view, aimbot.smooth)

		angle.clamp()
		g_csgo.set_view_angles(angle)
	}
}

// ##############################################
fn main() {

	init()

	mut raw_settings := os.read_file('config.cfg') or { panic(err) }
	settings := json.decode(Settings, raw_settings) or { panic(err) }

	/*
	pthread_t := &int(0)
	C.pthread_create(pthread_t, nullptr, wallhack, nullptr)
	C.pthread_create(pthread_t, nullptr, aimbot,   nullptr)
	C.pthread_join  (pthread_t, nullptr)
	*/

	process.attach('csgo.exe')
	g_mem = memory.Memory{handle: g_proc.handle}
	g_csgo = csgo.Csgo{}

	offset.update()

	for !memory.is_key_down(memory.Vkey.delete) {

		g_csgo.localplayer = g_csgo.localplayer()

		players := g_csgo.get_players()
		enemies := g_csgo.get_enemies_from(players)

		wallhack(players)
		aimbot(enemies, settings.aimbot)
		triggerbot(	settings.trigger)
	}
}

fn init() int {

	if !os.exists('config.cfg') {

		raw_settings := '{\n\t"_NOTE": "{key} use VirtualKey Enum : check it here [https://docs.microsoft.com/en-us/uwp/api/windows.system.virtualkey]",' +
		                '\n\n\t"_BONES": "head: 8 body: 6 right_hand: 39 left_hand: 13 right_leg: 73 left_leg: 66 right_foot: 74 left_foot: 67",'         +
		                '\n\n\t"aimbot":\n\t{\n\t\t"key": 86,\n\t\t"smooth": 10,\n\t\t"fov": 5,\n\t\t"bone": 8\n\t},'                                     +
		                '\n\n\t"trigger":\n\t{\n\t\t"key": 2,\n\t\t"delay": 0\n\t}\n}'
		
		mut file := os.create('config.cfg') or { panic(err)  }

		file.write(raw_settings)
		file.close()
	}
	return 1
}

struct Triggerbot {
	key memory.Vkey
	delay int
}

struct Aimbot {
	key 	memory.Vkey
	smooth 	f32
	fov 	f64
	bone 	csgo.Bone
}

struct Settings {
	aimbot 	Aimbot
	trigger Triggerbot
}
