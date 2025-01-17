extends Node3D


@export var damage : float = 0.5
@export var do_damage : bool = false
@onready var attack : WeaponSettings = Global.create_weapon_setting_to_damage(damage)


func _process(_delta: float) -> void:
	if do_damage:
		var areas : Array[Area3D] = $Area3D.get_overlapping_areas()
		
		if areas:
			for area in areas:
				if area is HitboxComponent:
					area.damage(attack)
	
