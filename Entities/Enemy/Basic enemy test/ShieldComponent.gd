extends Node3D
class_name ShieldComponent

@export var MAX_SHIELD: float
var shield : float

signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shield = MAX_SHIELD


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack: WeaponSettings = null, damage : float = 0.0):
	if attack:
		shield -= attack.damage
		get_parent().velocity += attack.global_pos.direction_to(get_parent().global_position) * attack.knockback_force
		print("SHIELDCOMPONENT:","Shield: ", shield)

	elif damage:
		shield -= damage
	
	if shield <= 0:
		queue_free()
		
		
