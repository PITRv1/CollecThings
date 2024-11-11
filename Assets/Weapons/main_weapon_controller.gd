@tool
class_name WeaponController extends Node3D

var current_weapon : Node3D = null
var current_weapon_settings

@export var sway_noise : NoiseTexture2D
@export var sway_speed : float = 1.2
@export var reset : bool = false

@export var weapon_list: Dictionary = {
	"TPistol": "res://Assets/Weapons/Pistol/pistol.tscn",
	"TShotgun": "res://Assets/Weapons/Shotgun/shotgun.tscn"
}

var mouse_movement : Vector2
var random_sway_x
var random_sway_y
var random_sway_amount : float
var time : float = 0.0
var idle_sway_adjustment
var idle_sway_rotaion_strenght
var weapon_bob_amount : Vector2 = Vector2(0,0)


func _ready():
	await owner.ready
	load_weapon(weapon_list["TShotgun"])
	
func _input(event):
	
	
	if event is InputEventMouseMotion:
		mouse_movement = event.relative
		
	if event.is_action_pressed("primary_fire"):
		current_weapon.primary_fire()
	if event.is_action_pressed("secondary_fire"):
		current_weapon.secondary_fire()
		
	
func load_weapon(weapon_scene_path: String) -> void:
	if current_weapon:
		current_weapon.queue_free()
	
	var weapon_scene: PackedScene = load(weapon_scene_path)
	
	if weapon_scene:
		current_weapon = weapon_scene.instantiate()
		#print(current_weapon)
		
		current_weapon_settings = current_weapon.weapon_settings
		add_child(current_weapon)
		apply_weapon_settings(current_weapon_settings)
		
	else:
		print("Failed to load weapon scene: ", weapon_scene_path)
	

func apply_weapon_settings(weapon_settings):
	position = weapon_settings.position
	rotation_degrees = weapon_settings.rotation
	scale = weapon_settings.scale
	#
	current_weapon_settings = weapon_settings
	
	idle_sway_adjustment = weapon_settings.idle_sway_adjustment
	idle_sway_rotaion_strenght = weapon_settings.idle_sway_rotation_strength
	random_sway_amount = weapon_settings.random_sway_amount


func sway_weapon(delta, isIdle : bool)->void:
	if Engine.is_editor_hint() or not (current_weapon and current_weapon_settings):
		return
	
	mouse_movement = mouse_movement.clamp(current_weapon_settings.sway_min, current_weapon_settings.sway_max)
	
	if isIdle:
		var sway_random : float = get_sway_noise()
		var sway_random_adjusted : float = sway_random * idle_sway_adjustment 
		
		time += delta * (sway_speed + sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount
	
	
		position.x = lerp(position.x, current_weapon_settings.position.x - (mouse_movement.x * current_weapon_settings.sway_amount_position + random_sway_x) * delta, current_weapon_settings.sway_speed_position)
		position.y = lerp(position.y, current_weapon_settings.position.y + (mouse_movement.y * current_weapon_settings.sway_amount_position + random_sway_y) * delta, current_weapon_settings.sway_speed_position)
		
		rotation_degrees.y = lerp(rotation_degrees.y, current_weapon_settings.rotation.y + (mouse_movement.x * current_weapon_settings.sway_amount_rotation + (random_sway_y * idle_sway_rotaion_strenght)) * delta, current_weapon_settings.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, current_weapon_settings.rotation.x - (mouse_movement.y * current_weapon_settings.sway_amount_rotation + (random_sway_x * idle_sway_rotaion_strenght)) * delta, current_weapon_settings.sway_speed_rotation)
	else:
		position.x = lerp(position.x, current_weapon_settings.position.x - (mouse_movement.x * current_weapon_settings.sway_amount_position + weapon_bob_amount.x) * delta, current_weapon_settings.sway_speed_position)
		position.y = lerp(position.y, current_weapon_settings.position.y + (mouse_movement.y * current_weapon_settings.sway_amount_position + weapon_bob_amount.y) * delta, current_weapon_settings.sway_speed_position)
		
		rotation_degrees.y = lerp(rotation_degrees.y, current_weapon_settings.rotation.y + (mouse_movement.x * current_weapon_settings.sway_amount_rotation) * delta, current_weapon_settings.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, current_weapon_settings.rotation.x - (mouse_movement.y * current_weapon_settings.sway_amount_rotation) * delta, current_weapon_settings.sway_speed_rotation)

func get_sway_noise()-> float:
	var player_position : Vector3 = Vector3(0,0,0)
	
	if not Engine.is_editor_hint():
		player_position = Global.player.global_position
		
	var noise_location: float = sway_noise.noise.get_noise_2d(player_position.x, player_position.y)
	return noise_location

func weapon_bob(delta, bob_speed: float, hbob_amount: float, vbob_amount: float)->void:
	time += delta
	
	weapon_bob_amount.x = sin(time * bob_speed) * hbob_amount
	weapon_bob_amount.y = abs(cos(time * bob_speed) * vbob_amount)
