// Created by Crowbar 0.71

$modelname "Carol.mdl"
$cd "."
$cdtexture "."
$cliptotextures
$scale 1.0


$bodygroup "leg"
{
	studio "leg"
}
$bodygroup "head"
{
	studio "head"
}
$bodygroup "dress"
{
	studio "body"
}
$bodygroup "dress"
{
	studio "body2"
}
$bodygroup "arm"
{
	studio "arm"
}


$flags 0


$attachment 0 "Bip01 R Hand" 13 1.5 4.25
$attachment 1 "Bip01 R Hand" 27 2.5 4.25
$attachment 2 "Bip01 R Hand" 35 3.5 -0.5
$attachment 3 "Bip01 L Hand" 13 1.5 -4.25

$cbox 0 0 0 0 0 0

$bbox 0 0 0 0 0 0

$hbox 3 "Bip01 Pelvis" -3.38482 -3.204392 -4.871542 2.88684 4.012707 4.871542
$hbox 6 "Bip01 L Leg" 1.919748 -2.66311 -2.230084 13.106253 3.521945 2.38886
$hbox 6 "Bip01 L Leg1" 0.27425 -2.865189 -2.049656 12.702096 2.88684 2.121827
$hbox 6 "Bip01 L Foot" -0.425809 -1.688801 -1.898097 2.735281 5.773679 1.580545
$hbox 7 "Bip01 R Leg" 1.782624 -2.66311 -2.280604 13.0846 3.521945 2.43938
$hbox 7 "Bip01 R Leg1" 0.22373 -2.865189 -2.049656 12.702096 2.843537 2.143478
$hbox 7 "Bip01 R Foot" -0.404158 -1.688801 -1.580545 2.749715 5.773679 1.919748
$hbox 3 "Bip01 Spine1" -2.345557 -3.969405 -3.969405 3.485859 3.969405 3.969405
$hbox 2 "Bip01 Spine2" -0.043303 -3.991056 -5.477779 5.773679 5.05197 5.477779
$hbox 2 "Bip01 Spine3" -1.623847 -4.914845 -4.553989 4.691114 3.673503 4.553989
$hbox 2 "Bip01 Neck" -2.244518 -1.082565 -2.16513 1.479505 2.525985 2.16513
$hbox 1 "Bip01 Head" 0.064954 -2.641458 -2.16513 6.069581 3.673503 2.16513
$hbox 4 "Bip01 L Arm" 0.678407 -2.078525 -2.980662 3.926102 3.088919 2.525985
$hbox 4 "Bip01 L Arm1" -1.558894 -1.688801 -1.847577 8.342967 2.461031 1.71767
$hbox 4 "Bip01 L Arm2" 0.425809 -1.306295 -1.580545 7.758382 2.049656 1.739321
$hbox 4 "Bip01 L Hand" 0 -0.72171 -1.44342 2.16513 1.082565 2.525985
$hbox 5 "Bip01 R Arm" 0.99596 -2.049656 -2.569287 4.106529 3.11057 3.11057
$hbox 5 "Bip01 R Arm1" -1.356815 -1.782624 -1.558894 8.523395 2.367208 2.028005
$hbox 5 "Bip01 R Arm2" 0.317552 -1.421769 -1.688801 7.642909 1.963051 1.602196
$hbox 5 "Bip01 R Hand" 0 -0.72171 -1.44342 2.16513 1.082565 2.525985

$controller 0 "Bip01 Spine" XR -30 30
$controller 1 "Bip01 Spine1" XR -30 30
$controller 2 "Bip01 Spine2" XR -30 30
$controller 3 "Bip01 Spine3" XR -30 30

$sequence "look_idle" {
	"touhou_remilia_anims\look_idle"
	ACT_IDLE 1
	fps 14
	loop
}
$sequence "idle" {
	"touhou_remilia_anims\idle"
	ACT_IDLE 1
	fps 14
	loop
}
$sequence "deep_idle" {
	"touhou_remilia_anims\deep_idle"
	ACT_IDLE 4
	fps 12
	loop
}
$sequence "run2" {
	"touhou_remilia_anims\run2"
	ACT_RUN 1
	fps 40
	loop
	LX
}
$sequence "walk2handed" {
	"touhou_remilia_anims\walk2handed"
	ACT_WALK 1
	fps 20
	loop
	LX
}
$sequence "2handshoot" {
	"touhou_remilia_anims\2handshoot"
	ACT_RANGE_ATTACK1 1
	fps 20
}
$sequence "crawl" {
	"touhou_remilia_anims\crawl"
	ACT_CROUCH 1
	fps 22
	loop
	LX
}
$sequence "crouch_idle" {
	"touhou_remilia_anims\crouch_idle"
	ACT_CROUCHIDLE 1
	fps 4
	loop
}
$sequence "jump" {
	"touhou_remilia_anims\jump"
	ACT_HOP 1
	fps 30
}
$sequence "long_jump" {
	"touhou_remilia_anims\long_jump"
	ACT_LEAP 1
	fps 24
	LX
}
$sequence "swim" {
	"touhou_remilia_anims\swim"
	ACT_SWIM 1
	fps 14
	loop
}
$sequence "treadwater" {
	"touhou_remilia_anims\treadwater"
	ACT_HOVER 1
	fps 14
	loop
}
$sequence "die_simple" {
	"touhou_remilia_anims\die_simple"
	ACT_DIESIMPLE 1
	{ event 2001 9 }
	fps 22
}
$sequence "die_backwards1" {
	"touhou_remilia_anims\die_backwards1"
	ACT_DIEBACKWARD 4
	{ event 2001 13 }
	fps 26
}
$sequence "die_backwards" {
	"touhou_remilia_anims\die_backwards"
	ACT_DIEBACKWARD 1
	{ event 2001 15 }
	fps 30
}
$sequence "die_forwards" {
	"touhou_remilia_anims\die_forwards"
	ACT_DIEFORWARD 1
	{ event 2001 8 }
	fps 26
}
$sequence "headshot" {
	"touhou_remilia_anims\headshot"
	ACT_DIE_HEADSHOT 4
	{ event 2001 22 }
	fps 24
}
$sequence "die_spin" {
	"touhou_remilia_anims\die_spin"
	ACT_DIE_HEADSHOT 1
	{ event 2001 16 }
	fps 30
}
$sequence "gutshot" {
	"touhou_remilia_anims\gutshot"
	ACT_DIE_GUTSHOT 1
	{ event 2001 22 }
	fps 26
}
$sequence "ref_draw_crowbar" {
	"touhou_remilia_anims\ref_draw_crowbar_blend01"
	"touhou_remilia_anims\ref_draw_crowbar_blend02"
	blend XR -70 70
	fps 12
}
$sequence "ref_aim_crowbar" {
	"touhou_remilia_anims\ref_aim_crowbar_blend01"
	"touhou_remilia_anims\ref_aim_crowbar_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_crowbar" {
	"touhou_remilia_anims\ref_shoot_crowbar_blend01"
	"touhou_remilia_anims\ref_shoot_crowbar_blend02"
	blend XR -70 70
	fps 24
}
$sequence "crouch_draw_crowbar" {
	"touhou_remilia_anims\crouch_draw_crowbar_blend01"
	"touhou_remilia_anims\crouch_draw_crowbar_blend02"
	blend XR -70 70
	fps 12
}
$sequence "crouch_aim_crowbar" {
	"touhou_remilia_anims\crouch_aim_crowbar_blend01"
	"touhou_remilia_anims\crouch_aim_crowbar_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_crowbar" {
	"touhou_remilia_anims\crouch_shoot_crowbar_blend01"
	"touhou_remilia_anims\crouch_shoot_crowbar_blend02"
	blend XR -70 70
	fps 24
}
$sequence "ref_cock_wrench" {
	"touhou_remilia_anims\ref_cock_wrench_blend01"
	"touhou_remilia_anims\ref_cock_wrench_blend02"
	blend XR -70 70
	fps 10
}
$sequence "ref_hold_wrench" {
	"touhou_remilia_anims\ref_hold_wrench_blend01"
	"touhou_remilia_anims\ref_hold_wrench_blend02"
	blend XR -70 70
	fps 13
}
$sequence "ref_shoot_wrench" {
	"touhou_remilia_anims\ref_shoot_wrench_blend01"
	"touhou_remilia_anims\ref_shoot_wrench_blend02"
	blend XR -70 70
	fps 13
}
$sequence "crouch_cock_wrench" {
	"touhou_remilia_anims\crouch_cock_wrench_blend01"
	"touhou_remilia_anims\crouch_cock_wrench_blend02"
	blend XR -70 70
	fps 10
}
$sequence "crouch_hold_wrench" {
	"touhou_remilia_anims\crouch_hold_wrench_blend01"
	"touhou_remilia_anims\crouch_hold_wrench_blend02"
	blend XR -70 70
	fps 13
}
$sequence "crouch_shoot_wrench" {
	"touhou_remilia_anims\crouch_shoot_wrench_blend01"
	"touhou_remilia_anims\crouch_shoot_wrench_blend02"
	blend XR -70 70
	fps 13
}
$sequence "ref_draw_gren" {
	"touhou_remilia_anims\ref_draw_gren_blend01"
	"touhou_remilia_anims\ref_draw_gren_blend02"
	blend XR -70 70
	fps 10
}
$sequence "ref_aim_gren" {
	"touhou_remilia_anims\ref_aim_gren_blend01"
	"touhou_remilia_anims\ref_aim_gren_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_cock_gren" {
	"touhou_remilia_anims\ref_cock_gren_blend01"
	"touhou_remilia_anims\ref_cock_gren_blend02"
	blend XR -70 70
	fps 18
}
$sequence "ref_hold_gren" {
	"touhou_remilia_anims\ref_hold_gren_blend01"
	"touhou_remilia_anims\ref_hold_gren_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_shoot_gren" {
	"touhou_remilia_anims\ref_shoot_gren_blend01"
	"touhou_remilia_anims\ref_shoot_gren_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_draw_gren" {
	"touhou_remilia_anims\crouch_draw_gren_blend01"
	"touhou_remilia_anims\crouch_draw_gren_blend02"
	blend XR -70 70
	fps 10
}
$sequence "crouch_aim_gren" {
	"touhou_remilia_anims\crouch_aim_gren_blend01"
	"touhou_remilia_anims\crouch_aim_gren_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_cock_gren" {
	"touhou_remilia_anims\crouch_cock_gren_blend01"
	"touhou_remilia_anims\crouch_cock_gren_blend02"
	blend XR -70 70
	fps 18
}
$sequence "crouch_hold_gren" {
	"touhou_remilia_anims\crouch_hold_gren_blend01"
	"touhou_remilia_anims\crouch_hold_gren_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_shoot_gren" {
	"touhou_remilia_anims\crouch_shoot_gren_blend01"
	"touhou_remilia_anims\crouch_shoot_gren_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_draw_trip" {
	"touhou_remilia_anims\ref_draw_trip_blend01"
	"touhou_remilia_anims\ref_draw_trip_blend02"
	blend XR -70 70
	fps 17
}
$sequence "ref_aim_trip" {
	"touhou_remilia_anims\ref_aim_trip_blend01"
	"touhou_remilia_anims\ref_aim_trip_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_trip" {
	"touhou_remilia_anims\ref_shoot_trip_blend01"
	"touhou_remilia_anims\ref_shoot_trip_blend02"
	blend XR -70 70
	fps 18
}
$sequence "crouch_draw_trip" {
	"touhou_remilia_anims\crouch_draw_trip_blend01"
	"touhou_remilia_anims\crouch_draw_trip_blend02"
	blend XR -70 70
	fps 17
}
$sequence "crouch_aim_trip" {
	"touhou_remilia_anims\crouch_aim_trip_blend01"
	"touhou_remilia_anims\crouch_aim_trip_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_trip" {
	"touhou_remilia_anims\crouch_shoot_trip_blend01"
	"touhou_remilia_anims\crouch_shoot_trip_blend02"
	blend XR -70 70
	fps 18
}
$sequence "ref_draw_onehanded" {
	"touhou_remilia_anims\ref_draw_onehanded_blend01"
	"touhou_remilia_anims\ref_draw_onehanded_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_onehanded" {
	"touhou_remilia_anims\ref_aim_onehanded_blend01"
	"touhou_remilia_anims\ref_aim_onehanded_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_onehanded" {
	"touhou_remilia_anims\ref_shoot_onehanded_blend01"
	"touhou_remilia_anims\ref_shoot_onehanded_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	fps 25
}
$sequence "ref_reload_onehanded" {
	"touhou_remilia_anims\ref_reload_onehanded_blend01"
	"touhou_remilia_anims\ref_reload_onehanded_blend02"
	blend XR -70 70
	fps 20
}
$sequence "crouch_draw_onehanded" {
	"touhou_remilia_anims\crouch_draw_onehanded_blend01"
	"touhou_remilia_anims\crouch_draw_onehanded_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_onehanded" {
	"touhou_remilia_anims\crouch_aim_onehanded_blend01"
	"touhou_remilia_anims\crouch_aim_onehanded_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_onehanded" {
	"touhou_remilia_anims\crouch_shoot_onehanded_blend01"
	"touhou_remilia_anims\crouch_shoot_onehanded_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	fps 25
}
$sequence "crouch_reload_onehanded" {
	"touhou_remilia_anims\crouch_reload_onehanded_blend01"
	"touhou_remilia_anims\crouch_reload_onehanded_blend02"
	blend XR -70 70
	fps 20
}
$sequence "ref_draw_python" {
	"touhou_remilia_anims\ref_draw_python_blend01"
	"touhou_remilia_anims\ref_draw_python_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_python" {
	"touhou_remilia_anims\ref_aim_python_blend01"
	"touhou_remilia_anims\ref_aim_python_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_python" {
	"touhou_remilia_anims\ref_shoot_python_blend01"
	"touhou_remilia_anims\ref_shoot_python_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	fps 16
}
$sequence "ref_reload_python" {
	"touhou_remilia_anims\ref_reload_python_blend01"
	"touhou_remilia_anims\ref_reload_python_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_draw_python" {
	"touhou_remilia_anims\crouch_draw_python_blend01"
	"touhou_remilia_anims\crouch_draw_python_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_python" {
	"touhou_remilia_anims\crouch_aim_python_blend01"
	"touhou_remilia_anims\crouch_aim_python_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_python" {
	"touhou_remilia_anims\crouch_shoot_python_blend01"
	"touhou_remilia_anims\crouch_shoot_python_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	fps 16
}
$sequence "crouch_reload_python" {
	"touhou_remilia_anims\crouch_reload_python_blend01"
	"touhou_remilia_anims\crouch_reload_python_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_draw_shotgun" {
	"touhou_remilia_anims\ref_draw_shotgun_blend01"
	"touhou_remilia_anims\ref_draw_shotgun_blend02"
	blend XR -70 70
	fps 18
}
$sequence "ref_aim_shotgun" {
	"touhou_remilia_anims\ref_aim_shotgun_blend01"
	"touhou_remilia_anims\ref_aim_shotgun_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_shotgun" {
	"touhou_remilia_anims\ref_shoot_shotgun_blend01"
	"touhou_remilia_anims\ref_shoot_shotgun_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_SG.txt" }
	fps 20
}
$sequence "ref_reload_shotgun" {
	"touhou_remilia_anims\ref_reload_shotgun_blend01"
	"touhou_remilia_anims\ref_reload_shotgun_blend02"
	blend XR -70 70
	fps 22
}
$sequence "crouch_draw_shotgun" {
	"touhou_remilia_anims\crouch_draw_shotgun_blend01"
	"touhou_remilia_anims\crouch_draw_shotgun_blend02"
	blend XR -70 70
	fps 18
}
$sequence "crouch_aim_shotgun" {
	"touhou_remilia_anims\crouch_aim_shotgun_blend01"
	"touhou_remilia_anims\crouch_aim_shotgun_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_shotgun" {
	"touhou_remilia_anims\crouch_shoot_shotgun_blend01"
	"touhou_remilia_anims\crouch_shoot_shotgun_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_SG.txt" }
	fps 20
}
$sequence "crouch_reload_shotgun" {
	"touhou_remilia_anims\crouch_reload_shotgun_blend01"
	"touhou_remilia_anims\crouch_reload_shotgun_blend02"
	blend XR -70 70
	fps 22
}
$sequence "ref_draw_gauss" {
	"touhou_remilia_anims\ref_draw_gauss_blend01"
	"touhou_remilia_anims\ref_draw_gauss_blend02"
	blend XR -70 70
	fps 18
}
$sequence "ref_aim_gauss" {
	"touhou_remilia_anims\ref_aim_gauss_blend01"
	"touhou_remilia_anims\ref_aim_gauss_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_gauss" {
	"touhou_remilia_anims\ref_shoot_gauss_blend01"
	"touhou_remilia_anims\ref_shoot_gauss_blend02"
	blend XR -70 70
	fps 20
}
$sequence "crouch_draw_gauss" {
	"touhou_remilia_anims\crouch_draw_gauss_blend01"
	"touhou_remilia_anims\crouch_draw_gauss_blend02"
	blend XR -70 70
	fps 18
}
$sequence "crouch_aim_gauss" {
	"touhou_remilia_anims\crouch_aim_gauss_blend01"
	"touhou_remilia_anims\crouch_aim_gauss_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_gauss" {
	"touhou_remilia_anims\crouch_shoot_gauss_blend01"
	"touhou_remilia_anims\crouch_shoot_gauss_blend02"
	blend XR -70 70
	fps 20
}
$sequence "ref_draw_mp5" {
	"touhou_remilia_anims\ref_draw_mp5_blend01"
	"touhou_remilia_anims\ref_draw_mp5_blend02"
	blend XR -70 70
	fps 17
}
$sequence "ref_aim_mp5" {
	"touhou_remilia_anims\ref_aim_mp5_blend01"
	"touhou_remilia_anims\ref_aim_mp5_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_mp5" {
	"touhou_remilia_anims\ref_shoot_mp5_blend01"
	"touhou_remilia_anims\ref_shoot_mp5_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_MP5.txt" }
	fps 30
}
$sequence "ref_reload_mp5" {
	"touhou_remilia_anims\ref_reload_mp5_blend01"
	"touhou_remilia_anims\ref_reload_mp5_blend02"
	blend XR -70 70
	fps 16
}
$sequence "crouch_draw_mp5" {
	"touhou_remilia_anims\crouch_draw_mp5_blend01"
	"touhou_remilia_anims\crouch_draw_mp5_blend02"
	blend XR -70 70
	fps 17
}
$sequence "crouch_aim_mp5" {
	"touhou_remilia_anims\crouch_aim_mp5_blend01"
	"touhou_remilia_anims\crouch_aim_mp5_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_mp5" {
	"touhou_remilia_anims\crouch_shoot_mp5_blend01"
	"touhou_remilia_anims\crouch_shoot_mp5_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_MP5.txt" }
	fps 30
}
$sequence "crouch_reload_mp5" {
	"touhou_remilia_anims\crouch_reload_mp5_blend01"
	"touhou_remilia_anims\crouch_reload_mp5_blend02"
	blend XR -70 70
	fps 16
}
$sequence "ref_draw_rpg" {
	"touhou_remilia_anims\ref_draw_rpg_blend01"
	"touhou_remilia_anims\ref_draw_rpg_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_rpg" {
	"touhou_remilia_anims\ref_aim_rpg_blend01"
	"touhou_remilia_anims\ref_aim_rpg_blend02"
	blend XR -70 70
	fps 10
	loop
}
$sequence "ref_shoot_rpg" {
	"touhou_remilia_anims\ref_shoot_rpg_blend01"
	"touhou_remilia_anims\ref_shoot_rpg_blend02"
	blend XR -70 70
	fps 18
}
$sequence "ref_reload_rpg" {
	"touhou_remilia_anims\ref_reload_rpg_blend01"
	"touhou_remilia_anims\ref_reload_rpg_blend02"
	blend XR -70 70
	fps 13
}
$sequence "crouch_draw_rpg" {
	"touhou_remilia_anims\crouch_draw_rpg_blend01"
	"touhou_remilia_anims\crouch_draw_rpg_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_rpg" {
	"touhou_remilia_anims\crouch_aim_rpg_blend01"
	"touhou_remilia_anims\crouch_aim_rpg_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_rpg" {
	"touhou_remilia_anims\crouch_shoot_rpg_blend01"
	"touhou_remilia_anims\crouch_shoot_rpg_blend02"
	blend XR -70 70
	fps 18
}
$sequence "crouch_reload_rpg" {
	"touhou_remilia_anims\crouch_reload_rpg_blend01"
	"touhou_remilia_anims\crouch_reload_rpg_blend02"
	blend XR -70 70
	fps 13
}
$sequence "ref_draw_egon" {
	"touhou_remilia_anims\ref_draw_egon_blend01"
	"touhou_remilia_anims\ref_draw_egon_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_egon" {
	"touhou_remilia_anims\ref_aim_egon_blend01"
	"touhou_remilia_anims\ref_aim_egon_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_egon" {
	"touhou_remilia_anims\ref_shoot_egon_blend01"
	"touhou_remilia_anims\ref_shoot_egon_blend02"
	blend XR -70 70
	fps 18
	loop
}
$sequence "crouch_draw_egon" {
	"touhou_remilia_anims\crouch_draw_egon_blend01"
	"touhou_remilia_anims\crouch_draw_egon_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_egon" {
	"touhou_remilia_anims\crouch_aim_egon_blend01"
	"touhou_remilia_anims\crouch_aim_egon_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_egon" {
	"touhou_remilia_anims\crouch_shoot_egon_blend01"
	"touhou_remilia_anims\crouch_shoot_egon_blend02"
	blend XR -70 70
	fps 18
	loop
}
$sequence "ref_draw_squeak" {
	"touhou_remilia_anims\ref_draw_squeak_blend01"
	"touhou_remilia_anims\ref_draw_squeak_blend02"
	blend XR -70 70
	fps 20
}
$sequence "ref_aim_squeak" {
	"touhou_remilia_anims\ref_aim_squeak_blend01"
	"touhou_remilia_anims\ref_aim_squeak_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_squeak" {
	"touhou_remilia_anims\ref_shoot_squeak_blend01"
	"touhou_remilia_anims\ref_shoot_squeak_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_draw_squeak" {
	"touhou_remilia_anims\crouch_draw_squeak_blend01"
	"touhou_remilia_anims\crouch_draw_squeak_blend02"
	blend XR -70 70
	fps 20
}
$sequence "crouch_aim_squeak" {
	"touhou_remilia_anims\crouch_aim_squeak_blend01"
	"touhou_remilia_anims\crouch_aim_squeak_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_squeak" {
	"touhou_remilia_anims\crouch_shoot_squeak_blend01"
	"touhou_remilia_anims\crouch_shoot_squeak_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_draw_hive" {
	"touhou_remilia_anims\ref_draw_hive_blend01"
	"touhou_remilia_anims\ref_draw_hive_blend02"
	blend XR -70 70
	fps 12
}
$sequence "ref_aim_hive" {
	"touhou_remilia_anims\ref_aim_hive_blend01"
	"touhou_remilia_anims\ref_aim_hive_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_hive" {
	"touhou_remilia_anims\ref_shoot_hive_blend01"
	"touhou_remilia_anims\ref_shoot_hive_blend02"
	blend XR -70 70
	fps 17
}
$sequence "crouch_draw_hive" {
	"touhou_remilia_anims\crouch_draw_hive_blend01"
	"touhou_remilia_anims\crouch_draw_hive_blend02"
	blend XR -70 70
	fps 12
}
$sequence "crouch_aim_hive" {
	"touhou_remilia_anims\crouch_aim_hive_blend01"
	"touhou_remilia_anims\crouch_aim_hive_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_hive" {
	"touhou_remilia_anims\crouch_shoot_hive_blend01"
	"touhou_remilia_anims\crouch_shoot_hive_blend02"
	blend XR -70 70
	fps 17
}
$sequence "ref_draw_bow" {
	"touhou_remilia_anims\ref_draw_bow_blend01"
	"touhou_remilia_anims\ref_draw_bow_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_bow" {
	"touhou_remilia_anims\ref_aim_bow_blend01"
	"touhou_remilia_anims\ref_aim_bow_blend02"
	blend XR -70 70
	fps 10
	loop
}
$sequence "ref_shoot_bow" {
	"touhou_remilia_anims\ref_shoot_bow_blend01"
	"touhou_remilia_anims\ref_shoot_bow_blend02"
	blend XR -70 70
	fps 20
}
$sequence "ref_aim_bowscope" {
	"touhou_remilia_anims\ref_aim_bowscope_blend01"
	"touhou_remilia_anims\ref_aim_bowscope_blend02"
	blend XR -70 70
	fps 6
	loop
}
$sequence "ref_shoot_bowscope" {
	"touhou_remilia_anims\ref_shoot_bowscope_blend01"
	"touhou_remilia_anims\ref_shoot_bowscope_blend02"
	blend XR -70 70
	fps 20
}
$sequence "ref_reload_bow" {
	"touhou_remilia_anims\ref_reload_bow_blend01"
	"touhou_remilia_anims\ref_reload_bow_blend02"
	blend XR -70 70
	fps 11
}
$sequence "crouch_draw_bow" {
	"touhou_remilia_anims\crouch_draw_bow_blend01"
	"touhou_remilia_anims\crouch_draw_bow_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_bow" {
	"touhou_remilia_anims\crouch_aim_bow_blend01"
	"touhou_remilia_anims\crouch_aim_bow_blend02"
	blend XR -70 70
	fps 10
	loop
}
$sequence "crouch_shoot_bow" {
	"touhou_remilia_anims\crouch_shoot_bow_blend01"
	"touhou_remilia_anims\crouch_shoot_bow_blend02"
	blend XR -70 70
	fps 20
}
$sequence "crouch_aim_bowscope" {
	"touhou_remilia_anims\crouch_aim_bowscope_blend01"
	"touhou_remilia_anims\crouch_aim_bowscope_blend02"
	blend XR -70 70
	fps 6
	loop
}
$sequence "crouch_shoot_bowscope" {
	"touhou_remilia_anims\crouch_shoot_bowscope_blend01"
	"touhou_remilia_anims\crouch_shoot_bowscope_blend02"
	blend XR -70 70
	fps 20
}
$sequence "crouch_reload_bow" {
	"touhou_remilia_anims\crouch_reload_bow_blend01"
	"touhou_remilia_anims\crouch_reload_bow_blend02"
	blend XR -70 70
	fps 11
}
$sequence "ref_draw_minigun" {
	"touhou_remilia_anims\ref_draw_minigun_blend01"
	"touhou_remilia_anims\ref_draw_minigun_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_minigun" {
	"touhou_remilia_anims\ref_aim_minigun_blend01"
	"touhou_remilia_anims\ref_aim_minigun_blend02"
	blend XR -70 70
	fps 8
	loop
}
$sequence "ref_shoot_minigun" {
	"touhou_remilia_anims\ref_shoot_minigun_blend01"
	"touhou_remilia_anims\ref_shoot_minigun_blend02"
	blend XR -70 70
	{ event 5021 0 "20" }
	fps 30
}
$sequence "crouch_draw_minigun" {
	"touhou_remilia_anims\crouch_draw_minigun_blend01"
	"touhou_remilia_anims\crouch_draw_minigun_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_minigun" {
	"touhou_remilia_anims\crouch_aim_minigun_blend01"
	"touhou_remilia_anims\crouch_aim_minigun_blend02"
	blend XR -70 70
	fps 8
	loop
}
$sequence "crouch_shoot_minigun" {
	"touhou_remilia_anims\crouch_shoot_minigun_blend01"
	"touhou_remilia_anims\crouch_shoot_minigun_blend02"
	blend XR -70 70
	{ event 5021 0 "20" }
	fps 30
}
$sequence "ref_draw_uzis" {
	"touhou_remilia_anims\ref_draw_uzis_blend01"
	"touhou_remilia_anims\ref_draw_uzis_blend02"
	blend XR -70 70
	fps 10
}
$sequence "ref_draw_uzis_left" {
	"touhou_remilia_anims\ref_draw_uzis_left_blend01"
	"touhou_remilia_anims\ref_draw_uzis_left_blend02"
	blend XR -70 70
	fps 11
}
$sequence "ref_aim_uzis" {
	"touhou_remilia_anims\ref_aim_uzis_blend01"
	"touhou_remilia_anims\ref_aim_uzis_blend02"
	blend XR -70 70
	fps 14
	loop
}
$sequence "ref_shoot_uzis_both" {
	"touhou_remilia_anims\ref_shoot_uzis_both_blend01"
	"touhou_remilia_anims\ref_shoot_uzis_both_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	{ event 5031 0 "15" }
	fps 24
}
$sequence "ref_shoot_uzis_right" {
	"touhou_remilia_anims\ref_shoot_uzis_right_blend01"
	"touhou_remilia_anims\ref_shoot_uzis_right_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	fps 24
}
$sequence "ref_shoot_uzis_left" {
	"touhou_remilia_anims\ref_shoot_uzis_left_blend01"
	"touhou_remilia_anims\ref_shoot_uzis_left_blend02"
	blend XR -70 70
	{ event 5031 0 "15" }
	fps 24
}
$sequence "ref_reload_uzis_right" {
	"touhou_remilia_anims\ref_reload_uzis_right_blend01"
	"touhou_remilia_anims\ref_reload_uzis_right_blend02"
	blend XR -70 70
	fps 14
}
$sequence "ref_reload_uzis_left" {
	"touhou_remilia_anims\ref_reload_uzis_left_blend01"
	"touhou_remilia_anims\ref_reload_uzis_left_blend02"
	blend XR -70 70
	fps 14
}
$sequence "crouch_draw_uzis" {
	"touhou_remilia_anims\crouch_draw_uzis_blend01"
	"touhou_remilia_anims\crouch_draw_uzis_blend02"
	blend XR -70 70
	fps 10
}
$sequence "crouch_draw_uzis_left" {
	"touhou_remilia_anims\crouch_draw_uzis_left_blend01"
	"touhou_remilia_anims\crouch_draw_uzis_left_blend02"
	blend XR -70 70
	fps 11
}
$sequence "crouch_aim_uzis" {
	"touhou_remilia_anims\crouch_aim_uzis_blend01"
	"touhou_remilia_anims\crouch_aim_uzis_blend02"
	blend XR -70 70
	fps 14
	loop
}
$sequence "crouch_shoot_uzis_both" {
	"touhou_remilia_anims\crouch_shoot_uzis_both_blend01"
	"touhou_remilia_anims\crouch_shoot_uzis_both_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	{ event 5031 0 "15" }
	fps 24
}
$sequence "crouch_shoot_uzis_right" {
	"touhou_remilia_anims\crouch_shoot_uzis_right_blend01"
	"touhou_remilia_anims\crouch_shoot_uzis_right_blend02"
	blend XR -70 70
	{ event 5001 0 "15" }
	fps 24
}
$sequence "crouch_shoot_uzis_left" {
	"touhou_remilia_anims\crouch_shoot_uzis_left_blend01"
	"touhou_remilia_anims\crouch_shoot_uzis_left_blend02"
	blend XR -70 70
	{ event 5031 0 "15" }
	fps 24
}
$sequence "crouch_reload_uzis_right" {
	"touhou_remilia_anims\crouch_reload_uzis_right_blend01"
	"touhou_remilia_anims\crouch_reload_uzis_right_blend02"
	blend XR -70 70
	fps 14
}
$sequence "crouch_reload_uzis_left" {
	"touhou_remilia_anims\crouch_reload_uzis_left_blend01"
	"touhou_remilia_anims\crouch_reload_uzis_left_blend02"
	blend XR -70 70
	fps 14
}
$sequence "ref_draw_m16" {
	"touhou_remilia_anims\ref_draw_m16_blend01"
	"touhou_remilia_anims\ref_draw_m16_blend02"
	blend XR -70 70
	fps 35
}
$sequence "ref_aim_m16" {
	"touhou_remilia_anims\ref_aim_m16_blend01"
	"touhou_remilia_anims\ref_aim_m16_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_m16" {
	"touhou_remilia_anims\ref_shoot_m16_blend01"
	"touhou_remilia_anims\ref_shoot_m16_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_spaw.txt" }
	fps 30
}
$sequence "ref_shoot_m203" {
	"touhou_remilia_anims\ref_shoot_m203_blend01"
	"touhou_remilia_anims\ref_shoot_m203_blend02"
	blend XR -70 70
	fps 30
}
$sequence "ref_reload_m16" {
	"touhou_remilia_anims\ref_reload_m16_blend01"
	"touhou_remilia_anims\ref_reload_m16_blend02"
	blend XR -70 70
	fps 32
}
$sequence "ref_reload_m203" {
	"touhou_remilia_anims\ref_reload_m203_blend01"
	"touhou_remilia_anims\ref_reload_m203_blend02"
	blend XR -70 70
	fps 35
}
$sequence "crouch_draw_m16" {
	"touhou_remilia_anims\crouch_draw_m16_blend01"
	"touhou_remilia_anims\crouch_draw_m16_blend02"
	blend XR -70 70
	fps 35
}
$sequence "crouch_aim_m16" {
	"touhou_remilia_anims\crouch_aim_m16_blend01"
	"touhou_remilia_anims\crouch_aim_m16_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_m16" {
	"touhou_remilia_anims\crouch_shoot_m16_blend01"
	"touhou_remilia_anims\crouch_shoot_m16_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_spaw.txt" }
	fps 30
}
$sequence "crouch_shoot_m203" {
	"touhou_remilia_anims\crouch_shoot_m203_blend01"
	"touhou_remilia_anims\crouch_shoot_m203_blend02"
	blend XR -70 70
	fps 30
}
$sequence "crouch_reload_m16" {
	"touhou_remilia_anims\crouch_reload_m16_blend01"
	"touhou_remilia_anims\crouch_reload_m16_blend02"
	blend XR -70 70
	fps 32
}
$sequence "crouch_reload_m203" {
	"touhou_remilia_anims\crouch_reload_m203_blend01"
	"touhou_remilia_anims\crouch_reload_m203_blend02"
	blend XR -70 70
	fps 35
}
$sequence "ref_draw_sniper" {
	"touhou_remilia_anims\ref_draw_sniper_blend01"
	"touhou_remilia_anims\ref_draw_sniper_blend02"
	blend XR -70 70
	fps 15
}
$sequence "ref_aim_sniper" {
	"touhou_remilia_anims\ref_aim_sniper_blend01"
	"touhou_remilia_anims\ref_aim_sniper_blend02"
	blend XR -70 70
	fps 10
	loop
}
$sequence "ref_shoot_sniper" {
	"touhou_remilia_anims\ref_shoot_sniper_blend01"
	"touhou_remilia_anims\ref_shoot_sniper_blend02"
	blend XR -70 70
	{ event 5021 0 "15" }
	fps 20
}
$sequence "ref_aim_sniperscope" {
	"touhou_remilia_anims\ref_aim_sniperscope_blend01"
	"touhou_remilia_anims\ref_aim_sniperscope_blend02"
	blend XR -70 70
	fps 6
	loop
}
$sequence "ref_shoot_sniperscope" {
	"touhou_remilia_anims\ref_shoot_sniperscope_blend01"
	"touhou_remilia_anims\ref_shoot_sniperscope_blend02"
	blend XR -70 70
	{ event 5011 0 "15" }
	fps 20
}
$sequence "ref_reload_sniper" {
	"touhou_remilia_anims\ref_reload_sniper_blend01"
	"touhou_remilia_anims\ref_reload_sniper_blend02"
	blend XR -70 70
	fps 22
}
$sequence "crouch_draw_sniper" {
	"touhou_remilia_anims\crouch_draw_sniper_blend01"
	"touhou_remilia_anims\crouch_draw_sniper_blend02"
	blend XR -70 70
	fps 15
}
$sequence "crouch_aim_sniper" {
	"touhou_remilia_anims\crouch_aim_sniper_blend01"
	"touhou_remilia_anims\crouch_aim_sniper_blend02"
	blend XR -70 70
	fps 10
	loop
}
$sequence "crouch_shoot_sniper" {
	"touhou_remilia_anims\crouch_shoot_sniper_blend01"
	"touhou_remilia_anims\crouch_shoot_sniper_blend02"
	blend XR -70 70
	{ event 5011 0 "15" }
	fps 20
}
$sequence "crouch_aim_sniperscope" {
	"touhou_remilia_anims\crouch_aim_sniperscope_blend01"
	"touhou_remilia_anims\crouch_aim_sniperscope_blend02"
	blend XR -70 70
	fps 6
	loop
}
$sequence "crouch_shoot_sniperscope" {
	"touhou_remilia_anims\crouch_shoot_sniperscope_blend01"
	"touhou_remilia_anims\crouch_shoot_sniperscope_blend02"
	blend XR -70 70
	{ event 5011 0 "15" }
	fps 20
}
$sequence "crouch_reload_sniper" {
	"touhou_remilia_anims\crouch_reload_sniper_blend01"
	"touhou_remilia_anims\crouch_reload_sniper_blend02"
	blend XR -70 70
	fps 22
}
$sequence "ref_draw_saw" {
	"touhou_remilia_anims\ref_draw_saw_blend01"
	"touhou_remilia_anims\ref_draw_saw_blend02"
	blend XR -70 70
	fps 24
}
$sequence "ref_aim_saw" {
	"touhou_remilia_anims\ref_aim_saw_blend01"
	"touhou_remilia_anims\ref_aim_saw_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "ref_shoot_saw" {
	"touhou_remilia_anims\ref_shoot_saw_blend01"
	"touhou_remilia_anims\ref_shoot_saw_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_spaw.txt" }
	fps 24
}
$sequence "ref_reload_saw" {
	"touhou_remilia_anims\ref_reload_saw_blend01"
	"touhou_remilia_anims\ref_reload_saw_blend02"
	blend XR -70 70
	fps 30
}
$sequence "crouch_draw_saw" {
	"touhou_remilia_anims\crouch_draw_saw_blend01"
	"touhou_remilia_anims\crouch_draw_saw_blend02"
	blend XR -70 70
	fps 24
}
$sequence "crouch_aim_saw" {
	"touhou_remilia_anims\crouch_aim_saw_blend01"
	"touhou_remilia_anims\crouch_aim_saw_blend02"
	blend XR -70 70
	fps 12
	loop
}
$sequence "crouch_shoot_saw" {
	"touhou_remilia_anims\crouch_shoot_saw_blend01"
	"touhou_remilia_anims\crouch_shoot_saw_blend02"
	blend XR -70 70
	{ event 5005 0 "muzzle_spaw.txt" }
	fps 24
}
$sequence "crouch_reload_saw" {
	"touhou_remilia_anims\crouch_reload_saw_blend01"
	"touhou_remilia_anims\crouch_reload_saw_blend02"
	blend XR -70 70
	fps 30
}
$sequence "deadback" {
	"touhou_remilia_anims\deadback"
	fps 10
}
$sequence "deadsitting" {
	"touhou_remilia_anims\deadsitting"
	fps 10
}
$sequence "deadstomach" {
	"touhou_remilia_anims\deadstomach"
	fps 10
}
$sequence "deadtable" {
	"touhou_remilia_anims\deadtable"
	fps 10
}
$sequence "ShannonCaldwell_v1.2" {
	"touhou_remilia_anims\ShannonCaldwell_v1.2"
	fps 10
}
$sequence "barnaclehit" {
	"touhou_remilia_anims\barnaclehit"
	ACT_BARNACLE_HIT 1
	fps 20
}
$sequence "barnaclepull" {
	"touhou_remilia_anims\barnaclepull"
	ACT_BARNACLE_PULL 1
	fps 25
	loop
}
$sequence "barnaclecrunch" {
	"touhou_remilia_anims\barnaclecrunch"
	ACT_BARNACLE_CHOMP 1
	fps 18
}
$sequence "barnaclechew" {
	"touhou_remilia_anims\barnaclechew"
	ACT_BARNACLE_CHEW 1
	fps 15
	loop
}
$sequence "use_console_loop" {
	"touhou_remilia_anims\use_console_loop"
	fps 10
	loop
}
$sequence "use_console_loop2" {
	"touhou_remilia_anims\use_console_loop2"
	fps 20
	loop
}
$sequence "action_retina" {
	"touhou_remilia_anims\action_retina"
	fps 18
}
$sequence "action_studycart" {
	"touhou_remilia_anims\action_studycart"
	fps 12
}
$sequence "action_wave" {
	"touhou_remilia_anims\action_wave"
	fps 10
}
