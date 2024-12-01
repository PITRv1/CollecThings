extends Node3D
class_name HealthComponent

@export var MAX_HEALTH : float
var health : float

signal died

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = MAX_HEALTH


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack: WeaponSettings = null, damage : float = 0.0):
	if attack:
		health -= attack.damage
		
		#get_parent().velocity += attack.global_pos.direction_to(get_parent().global_position) * attack.knockback_force

	elif damage:
		health -= damage

	if health <= 0:
		if get_parent() is Player:
			died.emit()
		else:
			get_parent().queue_free()
		
		
