module main

import memory
import process
import offset
import csgo

//#include <pthread.h>

fn C.pthread_create(voidptr, voidptr, voidptr, voidptr)
fn C.pthread_join(voidptr, voidptr)

__global nullptr voidptr = voidptr(0)

//##############################################

fn wallhack( players []csgo.Player ) {

	for player in players {

		if player.dormant() { continue }

		mut glow_t := player.get_glow()
		health := f32( player.health() )

		if player.is_enemy() {
			glow_t.r = f32( 1 - health / 100 )
			glow_t.g = f32( health / 100 )
			glow_t.b = f32( 0 )
		} 
		else {
			glow_t.r = f32(0.3)
			glow_t.g = f32(health / 100)
			glow_t.b = f32(1)
		}

		glow_t.a = f32(1)
		glow_t.when_occluded 	= true
        	glow_t.when_unoccluded 	= false
        	glow_t.full_bloom 		= false

		player.set_glow( glow_t )
		
		C.Sleep(1)
	}
}

//##############################################

fn triggerbot( vkey memory.Vkey ) {

	if !memory.is_key_down( vkey ) { 
		return
	}

	id := g_csgo.localplayer.crosshair_id()
	en := g_csgo.player_by_index( id )

	if en.is_alive() && en.is_enemy() {
		process.left_click()
	}
}

//##############################################

fn aimbot( players []csgo.Player, bone csgo.Bone, smooth_value f32, min_fov f64, vkey memory.Vkey ) {

	if !memory.is_key_down( vkey ) { 
		return 
	}

	vec_view := g_csgo.get_view_angles()
	aimpunch := g_csgo.localplayer.aimpunch()
	aim_from := g_csgo.localplayer.eyepos()

	mut fovs := []f64{}
	mut vecs := []csgo.Vector{}

	for player in players { 

		if	!player.is_spotted() {
			   continue
		}

		aim_to    := player.bone_pos( bone )
		mut angle := aim_from.angle_with( aim_to )
		en_fov    := ( vec_view + aimpunch ).fov_with( angle )
		
		if en_fov < min_fov {
			fovs << en_fov
			vecs << angle
		}
	}

	mut best_fov_index := 0
	mut best_fov := f64( 999 )

	for i, fov in fovs {
		if fov < best_fov {
			best_fov = fov
			best_fov_index = i
		}
	}

	if best_fov < min_fov {
		mut angle := vecs[ best_fov_index ] - aimpunch
		mut angle = angle.smooth_from( vec_view, smooth_value )
		angle.clamp()
		g_csgo.set_view_angles( angle )
	}
}

//##############################################

fn main() {

	/* pthread_t := &int(0)
	C.pthread_create(pthread_t, nullptr, wallhack, nullptr)
	C.pthread_create(pthread_t, nullptr, aimbot,   nullptr)
	C.pthread_join  (pthread_t, nullptr) */

	process.attach( 'csgo.exe' )
	g_mem  = memory.Memory{ handle: g_proc.handle }
	g_csgo = csgo.Csgo{}
	offset.update()

	for !memory.is_key_down( memory.Vkey.delete ) {

		g_csgo.localplayer = g_csgo.localplayer()
		players := g_csgo.get_players()
		enemies := g_csgo.get_enemies_from( players )	

		wallhack( players )
		aimbot( enemies, csgo.Bone.head, 10, 5, memory.Vkey.v )
		triggerbot( memory.Vkey.rightbutton )
	}
}
