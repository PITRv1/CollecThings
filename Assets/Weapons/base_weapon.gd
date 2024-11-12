extends Node3D
class_name BaseWeapon

@export var weapon_settings : WeaponSettings
@export var animation_player: AnimationPlayer
@export var projectile_origin: Marker3D
@export var cooldown_timer: Timer

var player : Player
var length := 100.0

var camera : Camera3D
var mousepos : Vector2
var space_state
var from
var to
var query
var result
var bloom

const PROJECTILE = preload("res://Assets/Weapons/Projectile.tscn")

func _ready() -> void:
	
	player = get_tree().get_first_node_in_group("player")
	weapon_settings.global_pos = player.global_position
	
# Primary fire function, can be overridden in derived weapons
func primary_fire():
	
	#Basic firing mechanic
	for i in range(weapon_settings.num_of_bullets):
		if weapon_settings.spread:
			var x = randf_range(-10.0 * weapon_settings.spread, 10.0 * weapon_settings.spread)
			var y = randf_range(-10.0 * weapon_settings.spread, 10.0 * weapon_settings.spread)
			bloom = Vector2(x, y)
		else:
			bloom = Vector2.ZERO
			
		# Get space, camera, mousepos
		space_state = get_world_3d().direct_space_state
		camera = get_viewport().get_camera_3d()
		mousepos = get_viewport().get_mouse_position()
		
		
		# Project ray
		from = camera.project_ray_origin(mousepos)
		
		to = from + camera.project_ray_normal(mousepos + bloom) * length
		query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.collide_with_bodies = false
		
		# This is a Dictionary, just select what you need from it, for example: position, collider, ect.
		result = space_state.intersect_ray(query)
		print(result)
		
		player.velocity += camera.global_transform.basis.z * weapon_settings.knockback_force/4
		
		if result.size() == 0:
		
			query = PhysicsRayQueryParameters3D.create(from, to)
			query.collide_with_bodies = true
			
			result = space_state.intersect_ray(query)
			
			if result.size() == 0: 
				
				var proj = PROJECTILE.instantiate()
				proj.global_position = projectile_origin.global_position
				proj.enter(weapon_settings)
				get_tree().root.add_child(proj)
				proj.look_at(to, Vector3.UP)
				continue
			
			var proj = PROJECTILE.instantiate()
			proj.global_position = projectile_origin.global_position
			proj.enter(weapon_settings)
			get_tree().root.add_child(proj)
			proj.look_at(result["position"], Vector3.UP)
		
		else:
		
			if result["collider"].has_method("damage") and weapon_settings.hitscan == 0:
				
				result["collider"].damage(weapon_settings)
			
			var proj = PROJECTILE.instantiate()
			proj.global_position = projectile_origin.global_position
			proj.enter(weapon_settings)
			get_tree().root.add_child(proj)
			proj.look_at(result["position"], Vector3.UP)


# Secondary fire function, can be overridden in derived weapons
func secondary_fire():
	pass
