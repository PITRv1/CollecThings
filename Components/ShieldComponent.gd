extends Node3D
class_name ShieldComponent


signal died
signal damaged
signal healed


@export var MAX_SHIELD: float

var shield : float
var shield_percent : float

func _ready() -> void:
	shield = MAX_SHIELD
	

func _process(_delta: float) -> void:
	shield_percent = shield/MAX_SHIELD
	

func damage(damage_amount : float = 0.0):
	if damage_amount:
		shield -= damage_amount
		damaged.emit()
		
	if shield <= 0:
		if get_parent() is not Player:
			died.emit()
			queue_free()
			
	
