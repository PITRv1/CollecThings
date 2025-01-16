extends Node3D
class_name BaseWeapon

@export var weapon_settings : WeaponSettings
@export var animation_player: AnimationPlayer
@export var projectile_origin: Marker3D
@export var cooldown_timer: Timer
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var is_primary_enabled: bool = true
var is_secondary_enabled: bool = true

@onready var player : Player = get_tree().get_first_node_in_group("player")
var length := 100.0

@onready var camera : Camera3D = get_viewport().get_camera_3d()
var mousepos : Vector2
var space_state : PhysicsDirectSpaceState3D
var from : Vector3
var to : Vector3
var query : PhysicsRayQueryParameters3D
var mag_size : int
var max_mag_size : int

@export var PROJECTILE : PackedScene = preload("res://Assets/Weapons/Projectile.tscn")
@export var rope_gen : PackedScene

func _ready() -> void:
	mag_size = weapon_settings.mag_size
	max_mag_size = weapon_settings.mag_size
	

# Primary fire function, can be overridden in derived weapons
func primary_fire() -> void:
	if not animation_player.is_playing() and is_primary_enabled and mag_size > 0 and cooldown_timer.is_stopped():
		
		if weapon_settings.hitscan == 1:
			
			projectile_primary()
			
		else:
			
			hitscan_primary()
			
		play_animations()
		
	elif not mag_size > 0:
		reload()

func hitscan_primary() -> void:
	
	var ray = run_ray_test(true, [])
	var hit_objects := []
	
	for i in range(weapon_settings.pierce):
		
		ray = run_ray_test(true, hit_objects)
		
		if ray.size() > 0:
			
			if ray["collider"] is HitboxComponent:
				
				ray["collider"].damage(weapon_settings)
				hit_objects.append(ray["collider"])
				
			else:
				break
		else:
			break
			
	cooldown_timer.start(weapon_settings.cooldown)
	mag_size -= 1
	draw_line(ray)

func play_animations() -> void:
	if animation_player.has_animation("knockback"):
		animation_player.play("knockback")
	
func draw_line(ray) -> void:
	var line = rope_gen.instantiate()
	if ray.size() > 0:
		line.SetPlayerPosition(projectile_origin.global_position)
		line.SetGrappleHookPosition(ray["position"])
		line.StartDrawing()
		line.visible = true
		get_tree().root.add_child(line)
	else:
		ray = run_ray_test(false, [])
		if ray.size() > 0:
			line.SetPlayerPosition(projectile_origin.global_position)
			line.SetGrappleHookPosition(ray["position"])
			line.StartDrawing()
			line.visible = true
			get_tree().root.add_child(line)
		else:
			line.SetPlayerPosition(projectile_origin.global_position)
			line.SetGrappleHookPosition(camera.project_ray_origin(mousepos) + camera.project_ray_normal(mousepos) * length)
			line.StartDrawing()
			line.visible = true
			get_tree().root.add_child(line)
			
func projectile_primary() -> void:
	
	for i in range(weapon_settings.num_of_bullets):
		
		spawn_bullet()
		
	mag_size -= 1

	cooldown_timer.start(weapon_settings.cooldown)

# Secondary fire function, can be overridden in derived weapons
func secondary_fire() -> void:
	pass
	

func reload() -> void:
	if mag_size != max_mag_size:
		if animation_player.has_animation("reload"):
			animation_player.play("reload")
	
func _reload() -> void:
	mag_size = weapon_settings.mag_size
	
func spawn_bullet() -> void:
	# Get space, camera, mousepos
	camera = get_viewport().get_camera_3d()
	space_state = get_world_3d().direct_space_state
	mousepos = get_viewport().get_mouse_position()
	
	# This is a Dictionary, just select what you need from it, for example: position, collider, ect.	
	var result = run_ray_test(true, [])
	
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

func run_ray_test(area_check, hit_objects) -> Dictionary:
	# Project ray
	camera = get_viewport().get_camera_3d()
	space_state = get_world_3d().direct_space_state
	mousepos = get_viewport().get_mouse_position()
	var dot_pos = player.crosshair.position
	mousepos = dot_pos
	from = camera.project_ray_origin(mousepos)
	var bloom = calculate_spread()
	to = from + camera.project_ray_normal(mousepos + bloom) * length

	query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = hit_objects
	
	if area_check:
		query.collide_with_areas = true
		query.collide_with_bodies = false
	else:
		query.collide_with_areas = false
		query.collide_with_bodies = true
	
	return space_state.intersect_ray(query)

func instantiate_projectile(target) -> void:
	var proj = PROJECTILE.instantiate()
	if proj:
		proj.global_position = projectile_origin.global_position
		proj.enter(weapon_settings)
		get_tree().current_scene.add_child(proj)
		proj.look_at(target, Vector3.UP)
