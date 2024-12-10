extends Node3D
class_name ShieldComponent

@export var MAX_SHIELD: float
var shield : float
var shield_percent : float

signal died

func _ready() -> void:
	shield = MAX_SHIELD
	


func _process(delta: float) -> void:
	shield_percent = shield/MAX_SHIELD-1 
	


func damage(attack: WeaponSettings = null, damage : float = 0.0):
	if attack:
		shield -= attack.damage
		#get_parent().velocity += attack.global_pos.direction_to(get_parent().global_position) * attack.knockback_force
		

	elif damage:
		shield -= damage
	
	if shield <= 0:
		if get_parent() is Player:
			pass
		else:
			queue_free()
		
		
