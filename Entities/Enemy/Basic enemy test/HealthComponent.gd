extends Node3D
class_name HealthComponent

@export var MAX_HEALTH : float
var health : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	print(MAX_HEALTH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack: WeaponSettings):
	health -= attack.damage
	
	if health <= 0:
		get_parent().queue_free()
		
	print(get_parent().global_position.direction_to(attack.global_pos) * attack.knockback_force)
		
	get_parent().velocity += attack.global_pos.direction_to(get_parent().global_position) * attack.knockback_force
	
