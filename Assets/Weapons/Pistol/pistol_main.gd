extends BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/BulletDecal.tscn")

var charge : float
var knock_force : float

func _ready() -> void:
	charge = 0.0
	knock_force = weapon_settings.knockback_force 

func _process(delta: float) -> void:
	if Input.is_action_pressed("secondary_fire"):
		charge += delta
	elif charge > 0:
		_secondary_fire()

func _secondary_fire():
	weapon_settings.knockback_force += charge * 30
	spawn_bullet()
	charge = 0.0
	weapon_settings.knockback_force += knock_force
