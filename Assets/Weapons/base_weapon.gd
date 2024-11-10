extends Node3D

@export var weapon_settings : WeaponSettings
@export var animation_player: AnimationPlayer
@export var projectile_origin: Marker3D
@export var cooldown_timer: Timer

# Primary fire function, can be overridden in derived weapons
func primary_fire():
	pass

# Secondary fire function, can be overridden in derived weapons
func secondary_fire():
	pass
