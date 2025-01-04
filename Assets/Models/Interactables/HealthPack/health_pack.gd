extends Node3D

@export var heal_amount :int = 45
var attack := WeaponSettings.new()

func _ready() -> void:
	attack.damage = 1

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is HitboxComponent:
		area.heal(heal_amount)
		$HitboxComponent.damage(attack)
	
