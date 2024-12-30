extends Node3D
class_name ShieldComponent

@export var MAX_SHIELD: float
var shield : float
var shield_percent : float


signal died
signal damaged
signal healed


func _ready() -> void:
	shield = MAX_SHIELD
	


func _process(_delta: float) -> void:
	shield_percent = shield/MAX_SHIELD


func damage(attack: WeaponSettings = null, damage : float = 0.0):
	if attack:
		shield -= attack.damage
		
	
	elif damage:
		shield -= damage
		
	
	damaged.emit()
	
	if shield <= 0:
		if get_parent() is Player:
			pass
		else:
			queue_free()
			
	
