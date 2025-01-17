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

func damage(damage_amount : float = 0.0):
	if damage_amount:
		health -= damage_amount
		damaged.emit()
		
		#get_parent().velocity += attack.global_pos.direction_to(get_parent().global_position) * attack.knockback_force
		
	
	if health <= 0:
		if get_parent() is not Player:
			get_parent().queue_free()
		
		died.emit()

func heal(amount: int) -> void:
	health += amount
	
	if health > MAX_HEALTH:
		health = MAX_HEALTH
	
	healed.emit()
