extends Node3D
class_name HealthComponent

@export var MAX_HEALTH : float
var health : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH
	print(MAX_HEALTH)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack: Attack):
	health -= attack.attack_damage
	print(health)
	
	if health <= 0:
		get_parent().queue_free()
		
	get_parent().velocity += (get_parent().global_position - attack.attack_position).normalized() * attack.knockback_force
	
