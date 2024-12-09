class_name WeaponSettings extends Resource

@export var name: StringName

@export_category("Weapon Specs")
@export var damage : float
@export var cooldown : float
@export var knockback_force: float
@export var stun_time : float
@export_range(0.0, 10.0, .1) var spread = 1.0
@export var num_of_bullets : int
@export_enum("Hitscan", "Projectile") var hitscan: int = 0
@export var proj_speed : float
@export var pierce : int
@export var mag_size : int

@export_category("Weapon Orientation")
@export var position: Vector3
var global_pos : Vector3
@export var rotation: Vector3
@export var scale: Vector3

@export_category("Weapon Sway")
@export var sway_min : Vector2 = Vector2(-20.0,-20.0)
@export var sway_max : Vector2 = Vector2(20.0,20.0)
@export_range(0,0.2,0.01) var sway_speed_position : float = 0.07
@export_range(0,0.2,0.01) var sway_speed_rotation : float = 0.1
@export_range(0,0.25,0.01) var sway_amount_position : float = 0.1
@export_range(0,50.0,0.1) var sway_amount_rotation : float = 30.0

@export var idle_sway_adjustment : float = 10.0
@export var idle_sway_rotation_strength : float = 300.0
@export_range(0.1,10.0,0.1) var random_sway_amount :float = 5.0

@export_category("HUD")
@export var speacial_icon_path : CompressedTexture2D = preload("res://Assets/UI/Resources/Icons/Weapons/no_special.png")
