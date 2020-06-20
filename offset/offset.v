module offset

import net.http
import json

__global g_sgn map[string]int
__global g_ntv Netvar
__global o_sgn Signature

fn init() int {
	g_sgn = map[string]int{}
	return 1
}

struct Signature {
pub:
	anim_overlays                     int [json:anim_overlays                    ]
	clientstate_choked_commands       int [json:clientstate_choked_commands      ]
	clientstate_delta_ticks           int [json:clientstate_delta_ticks          ]
	clientstate_last_outgoing_command int [json:clientstate_last_outgoing_command]
	clientstate_net_channel           int [json:clientstate_net_channel          ]
	convar_name_hash_table            int [json:convar_name_hash_table           ]
	dwclientstate                     int [json:dwClientState                    ]
	dwclientstate_getlocalplayer      int [json:dwClientState_GetLocalPlayer     ]
	dwclientstate_ishltv              int [json:dwClientState_IsHLTV             ]
	dwclientstate_map                 int [json:dwClientState_Map                ]
	dwclientstate_mapdirectory        int [json:dwClientState_MapDirectory       ]
	dwclientstate_maxplayer           int [json:dwClientState_MaxPlayer          ]
	dwclientstate_playerinfo          int [json:dwClientState_PlayerInfo         ]
	dwclientstate_state               int [json:dwClientState_State              ]
	dwclientstate_viewangles          int [json:dwClientState_ViewAngles         ]
	dwentitylist                      int [json:dwEntityList                     ]
	dwforceattack                     int [json:dwForceAttack                    ]
	dwforceattack2                    int [json:dwForceAttack2                   ]
	dwforcebackward                   int [json:dwForceBackward                  ]
	dwforceforward                    int [json:dwForceForward                   ]
	dwforcejump                       int [json:dwForceJump                      ]
	dwforceleft                       int [json:dwForceLeft                      ]
	dwforceright                      int [json:dwForceRight                     ]
	dwgamedir                         int [json:dwGameDir                        ]
	dwgamerulesproxy                  int [json:dwGameRulesProxy                 ]
	dwgetallclasses                   int [json:dwGetAllClasses                  ]
	dwglobalvars                      int [json:dwGlobalVars                     ]
	dwglowobjectmanager               int [json:dwGlowObjectManager              ]
	dwinput                           int [json:dwInput                          ]
	dwinterfacelinklist               int [json:dwInterfaceLinkList              ]
	dwlocalplayer                     int [json:dwLocalPlayer                    ]
	dwmouseenable                     int [json:dwMouseEnable                    ]
	dwmouseenableptr                  int [json:dwMouseEnablePtr                 ]
	dwplayerresource                  int [json:dwPlayerResource                 ]
	dwradarbase                       int [json:dwRadarBase                      ]
	dwsensitivity                     int [json:dwSensitivity                    ]
	dwsensitivityptr                  int [json:dwSensitivityPtr                 ]
	dwsetclantag                      int [json:dwSetClanTag                     ]
	dwviewmatrix                      int [json:dwViewMatrix                     ]
	dwweapontable                     int [json:dwWeaponTable                    ]
	dwweapontableindex                int [json:dwWeaponTableIndex               ]
	dwyawptr                          int [json:dwYawPtr                         ]
	dwzoomsensitivityratioptr         int [json:dwZoomSensitivityRatioPtr        ]
	dwbsendpackets                    int [json:dwbSendPackets                   ]
	dwppdirectddevice                 int [json:dwppDirectDDevice                ]
	find_hud_element                  int [json:find_hud_element                 ]
	force_update_spectator_glow       int [json:force_update_spectator_glow      ]
	interface_engine_cvar             int [json:interface_engine_cvar            ]
	is_c_owner                        int [json:is_c_owner                       ]
	m_bdormant                        int [json:m_bDormant                       ]
	m_flspawntime                     int [json:m_flSpawnTime                    ]
	m_pstudiohdr                      int [json:m_pStudioHdr                     ]
	m_pitchclassptr                   int [json:m_pitchClassPtr                  ]
	m_yawclassptr                     int [json:m_yawClassPtr                    ]
	model_ambient_min                 int [json:model_ambient_min                ]
	set_abs_angles                    int [json:set_abs_angles                   ]
	set_abs_origin                    int [json:set_abs_origin                   ]
}

pub struct Netvar {
pub:
	cs_gamerules_data               int [json:cs_gamerules_data              ]
	m_armorvalue                    int [json:m_ArmorValue                   ]
	m_collision                     int [json:m_Collision                    ]
	m_collisiongroup                int [json:m_CollisionGroup               ]
	m_local                         int [json:m_Local                        ]
	m_movetype                      int [json:m_MoveType                     ]
	m_originalownerxuidhigh         int [json:m_OriginalOwnerXuidHigh        ]
	m_originalownerxuidlow          int [json:m_OriginalOwnerXuidLow         ]
	m_survivalgameruledecisiontypes int [json:m_SurvivalGameRuleDecisionTypes]
	m_survivalrules                 int [json:m_SurvivalRules                ]
	m_aimpunchangle                 int [json:m_aimPunchAngle                ]
	m_aimpunchanglevel              int [json:m_aimPunchAngleVel             ]
	m_angeyeanglesx                 int [json:m_angEyeAnglesX                ]
	m_angeyeanglesy                 int [json:m_angEyeAnglesY                ]
	m_bbombplanted                  int [json:m_bBombPlanted                 ]
	m_bfreezeperiod                 int [json:m_bFreezePeriod                ]
	m_bgungameimmunity              int [json:m_bGunGameImmunity             ]
	m_bhasdefuser                   int [json:m_bHasDefuser                  ]
	m_bhashelmet                    int [json:m_bHasHelmet                   ]
	m_binreload                     int [json:m_bInReload                    ]
	m_bisdefusing                   int [json:m_bIsDefusing                  ]
	m_bisqueuedmatchmaking          int [json:m_bIsQueuedMatchmaking         ]
	m_bisscoped                     int [json:m_bIsScoped                    ]
	m_bisvalveds                    int [json:m_bIsValveDS                   ]
	m_bspotted                      int [json:m_bSpotted                     ]
	m_bspottedbymask                int [json:m_bSpottedByMask               ]
	m_bstartedarming                int [json:m_bStartedArming               ]
	m_busecustomautoexposuremax     int [json:m_bUseCustomAutoExposureMax    ]
	m_busecustomautoexposuremin     int [json:m_bUseCustomAutoExposureMin    ]
	m_busecustombloomscale          int [json:m_bUseCustomBloomScale         ]
	m_clrrender                     int [json:m_clrRender                    ]
	m_dwbonematrix                  int [json:m_dwBoneMatrix                 ]
	m_faccuracypenalty              int [json:m_fAccuracyPenalty             ]
	m_fflags                        int [json:m_fFlags                       ]
	m_flcblow                       int [json:m_flCBlow                      ]
	m_flcustomautoexposuremax       int [json:m_flCustomAutoExposureMax      ]
	m_flcustomautoexposuremin       int [json:m_flCustomAutoExposureMin      ]
	m_flcustombloomscale            int [json:m_flCustomBloomScale           ]
	m_fldefusecountdown             int [json:m_flDefuseCountDown            ]
	m_fldefuselength                int [json:m_flDefuseLength               ]
	m_flfallbackwear                int [json:m_flFallbackWear               ]
	m_flflashduration               int [json:m_flFlashDuration              ]
	m_flflashmaxalpha               int [json:m_flFlashMaxAlpha              ]
	m_fllastbonesetuptime           int [json:m_flLastBoneSetupTime          ]
	m_fllowerbodyyawtarget          int [json:m_flLowerBodyYawTarget         ]
	m_flnextattack                  int [json:m_flNextAttack                 ]
	m_flnextprimaryattack           int [json:m_flNextPrimaryAttack          ]
	m_flsimulationtime              int [json:m_flSimulationTime             ]
	m_fltimerlength                 int [json:m_flTimerLength                ]
	m_hactiveweapon                 int [json:m_hActiveWeapon                ]
	m_hmyweapons                    int [json:m_hMyWeapons                   ]
	m_hobservertarget               int [json:m_hObserverTarget              ]
	m_howner                        int [json:m_hOwner                       ]
	m_hownerentity                  int [json:m_hOwnerEntity                 ]
	m_iaccountid                    int [json:m_iAccountID                   ]
	m_iclip                         int [json:m_iClip                        ]
	m_icompetitiveranking           int [json:m_iCompetitiveRanking          ]
	m_icompetitivewins              int [json:m_iCompetitiveWins             ]
	m_icrosshairid                  int [json:m_iCrosshairId                 ]
	m_ientityquality                int [json:m_iEntityQuality               ]
	m_ifov                          int [json:m_iFOV                         ]
	m_ifovstart                     int [json:m_iFOVStart                    ]
	m_iglowindex                    int [json:m_iGlowIndex                   ]
	m_ihealth                       int [json:m_iHealth                      ]
	m_iitemdefinitionindex          int [json:m_iItemDefinitionIndex         ]
	m_iitemidhigh                   int [json:m_iItemIDHigh                  ]
	m_imostrecentmodelbonecounter   int [json:m_iMostRecentModelBoneCounter  ]
	m_iobservermode                 int [json:m_iObserverMode                ]
	m_ishotsfired                   int [json:m_iShotsFired                  ]
	m_istate                        int [json:m_iState                       ]
	m_iteamnum                      int [json:m_iTeamNum                     ]
	m_lifestate                     int [json:m_lifeState                    ]
	m_nfallbackpaintkit             int [json:m_nFallbackPaintKit            ]
	m_nfallbackseed                 int [json:m_nFallbackSeed                ]
	m_nfallbackstattrak             int [json:m_nFallbackStatTrak            ]
	m_nforcebone                    int [json:m_nForceBone                   ]
	m_ntickbase                     int [json:m_nTickBase                    ]
	m_rgflcoordinateframe           int [json:m_rgflCoordinateFrame          ]
	m_szcustomname                  int [json:m_szCustomName                 ]
	m_szlastplacename               int [json:m_szLastPlaceName              ]
	m_thirdpersonviewangles         int [json:m_thirdPersonViewAngles        ]
	m_vecorigin                     int [json:m_vecOrigin                    ]
	m_vecvelocity                   int [json:m_vecVelocity                  ]
	m_vecviewoffset                 int [json:m_vecViewOffset                ]
	m_viewpunchangle                int [json:m_viewPunchAngle               ]
}

struct Offset {
pub:
	timestamp  i64
	signatures Signature
	netvars    Netvar
}

struct Sig {
pub:
	name     string
	extra    int
	relative bool
	mod_name string [json:@module]
	offsets  []int
	pattern  string
}

pub fn (s Sig) offset() int {
	mut ret := 0
	for offset in s.offsets {
		ret += offset
	}
	return ret
}

struct Sigs {
pub:
	executable string
	filename   string
	signatures []Sig
}

pub fn update() {
	println('[~] pattern scanning signatures ..')
	offs_json := http.get('https://raw.githubusercontent.com/frk1/hazedumper/master/csgo.json'  ) or { panic(err) }
	sigs_json := http.get('https://raw.githubusercontent.com/frk1/hazedumper/master/config.json') or { panic(err) }

	offs := json.decode(Offset, offs_json.text) or { panic(err) }
	sigs := json.decode(Sigs, sigs_json.text)   or { panic(err) }

	g_ntv = offs.netvars
	o_sgn = offs.signatures

	mut count := 0
	needed_sigs := [
		'm_bDormant'              ,
		'dwClientState_ViewAngles',
		'dwLocalPlayer'           ,
		'dwClientState_MaxPlayer' ,
		'dwGlowObjectManager'     ,
		'dwEntityList'            ,
		'dwClientState'           ,
		'dwForceJump'
	]
    
	for sig in sigs.signatures {
		for needed_sig in needed_sigs {
			if needed_sig == sig.name {
				g_sgn[sig.name] = g_mem.sig_scan(sig)
				if g_sgn[sig.name] != -1 {
					count++
				}
			}
		}
	}
	println('[+] found $needed_sigs.len / $count signatures')
}
