extends Node3D
class_name HealthComponent

@export var MAX_HEALTH : float

var health : float
var health_percent : float

signal died
signal damaged
signal healed

func _ready() -> void:
	health = MAX_HEALTH

func _process(_delta: float) -> void:
	health_percent = health/MAX_HEALTH

func damage(attack: WeaponSettings = null, damage : float = 0.0):
	if attack:
		health -= attack.damage
		#get_parent().velocity += attack.global_pos.direction_to(get_parent().global_position) * attack.knockback_force
	
	elif damage:
		health -= damage
	
	damaged.emit()
	
	if health <= 0:
		if get_parent() is Player:
			died.emit()
		else:
			get_parent().queue_free()
