extends Area3D

@export var damage : float = 1.0
@onready var attack : WeaponSettings = Global.create_weapon_setting_to_damage(damage)

func _process(_delta: float) -> void:
	var areas : Array[Area3D] = self.get_overlapping_areas()
	
	if areas:
		for area: HitboxComponent in areas:
			area.damage(attack)
	
