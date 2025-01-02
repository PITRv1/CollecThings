extends Node3D
class_name BaseWeapon

@export var weapon_settings : WeaponSettings
@export var animation_player: AnimationPlayer
@export var projectile_origin: Marker3D
@export var cooldown_timer: Timer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var player : Player
var length := 100.0

var camera : Camera3D
var mousepos : Vector2
var space_state : PhysicsDirectSpaceState3D
var from : Vector3
var to : Vector3
var query : PhysicsRayQueryParameters3D
var mag_size : int
var max_mag_size : int

@export var PROJECTILE : PackedScene = preload("res://Assets/Weapons/Projectile.tscn")

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	print(player)
	mag_size = weapon_settings.mag_size
	max_mag_size = weapon_settings.mag_size
	camera = get_viewport().get_camera_3d()

# Primary fire function, can be overridden in derived weapons
func primary_fire():
	if not animation_player.is_playing():
		if mag_size > 0:
			if weapon_settings.hitscan == 1:
				if cooldown_timer.is_stopped():
					for i in range(weapon_settings.num_of_bullets):
						#audio_stream_player_3d.stream = load("res://Assets/Sounds/dash_itself_v1.mp3")
						#audio_stream_player_3d.play()
						spawn_bullet()
					mag_size -= 1

					if animation_player.has_animation("knockback"):
						animation_player.play("knockback")
						print("heh")
					cooldown_timer.start(weapon_settings.cooldown)
					if mag_size <= 0:
						reload()
			else:
				var ray = run_ray_test()
				if ray.size() > 0:
					if ray["collider"] is HitboxComponent:
						ray["collider"].damage(weapon_settings)
		else:
			reload()
		
	

# Secondary fire function, can be overridden in derived weapons
func secondary_fire():
	pass
	
func reload():
	if mag_size != max_mag_size:
		print("borger")
		if animation_player.has_animation("reload"):
			animation_player.play("reload")
	else:
		print("You dumb af abald")
	
func _reload():
	mag_size = weapon_settings.mag_size
	
func spawn_bullet():
	# Get space, camera, mousepos
	camera = get_viewport().get_camera_3d()
	space_state = get_world_3d().direct_space_state
	mousepos = get_viewport().get_mouse_position()
	
	# This is a Dictionary, just select what you need from it, for example: position, collider, ect.	
	var result = run_ray_test()
	player.velocity += get_viewport().get_camera_3d().global_transform.basis.z * weapon_settings.knockback_force/4
	if result.size() == 0:
		query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_bodies = true
		
		result = space_state.intersect_ray(query)
		
		if result.size() == 0: 
			instantiate_projectile(to)
			return
		
		instantiate_projectile(result["position"]) 
	
	else:
		if result["collider"].has_method("damage") and weapon_settings.hitscan == 0:
			result["collider"].damage(weapon_settings)
		instantiate_projectile(result["position"])

func calculate_spread() -> Vector2:
	var spread : Vector2

	if weapon_settings.spread:
		var x = randf_range(-10.0 * weapon_settings.spread, 10.0 * weapon_settings.spread)
		var y = randf_range(-10.0 * weapon_settings.spread, 10.0 * weapon_settings.spread)
		spread = Vector2(x, y)
	else:
		spread = Vector2.ZERO
		
	return spread

func run_ray_test() -> Dictionary:
	# Project ray
	camera = get_viewport().get_camera_3d()
	space_state = get_world_3d().direct_space_state
	mousepos = get_viewport().get_mouse_position()
	from = camera.project_ray_origin(mousepos)
	
	var bloom = calculate_spread()
	to = from + camera.project_ray_normal(mousepos + bloom) * length
	
	query = PhysicsRayQueryParameters3D.create(from, to)
	
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	return space_state.intersect_ray(query)

func instantiate_projectile(target) -> void:
	var proj = PROJECTILE.instantiate()
	if proj:
		proj.global_position = projectile_origin.global_position
		proj.enter(weapon_settings)
		get_tree().root.add_child(proj)
		proj.look_at(target, Vector3.UP)
