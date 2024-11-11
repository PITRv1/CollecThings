extends "res://Assets/Weapons/base_weapon.gd"

@onready var b_decal
@onready var marker_3d: Marker3D = $Marker3D

var player : CharacterBody3D
var hit : Node3D
var length := 100.0

var attack_damage := 1.0
var knockback_force := 5.0
var stun_time := 1.5

var attack
var camera
var mousepos
var space_state
var from
var to
var query
var result

const PROJECTILE = preload("res://Assets/Weapons/Pistol/Projectile.tscn")

func _ready() -> void:
	attack = Attack.new()
	attack.attack_damage = attack_damage
	attack.knockback_force = knockback_force
	b_decal = preload("res://Assets/Models/BulletDecal.tscn")
	

func primary_fire():
	
	# Get space, camera, mousepos
	
	space_state = get_world_3d().direct_space_state
	camera = get_viewport().get_camera_3d()
	mousepos = get_viewport().get_mouse_position()
	
	# Project ray
	from = camera.project_ray_origin(mousepos)
	to = from + camera.project_ray_normal(mousepos) * length
	query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	# This is a Dictionary, just select what you need from it, for example: position, collider, ect.
	result = space_state.intersect_ray(query)
	
	if result.size() == 0:
	
		query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_bodies = true
		
		result = space_state.intersect_ray(query)
		
		if result.size() == 0: return
		
		var proj = PROJECTILE.instantiate()
		proj.global_position = marker_3d.global_position
		add_child(proj)
		proj.look_at(result["position"], Vector3.UP)
	
	else:
	
		if result["collider"].has_method("damage"):
			
			result["collider"].damage(attack)
		
		var proj = PROJECTILE.instantiate()
		proj.global_position = marker_3d.global_position
		add_child(proj)
		proj.look_at(result["position"], Vector3.UP)
