extends Node3D


var attack : WeaponSettings = WeaponSettings.new()

@export var damage : float = 0.5
@export var do_damage : bool = false

func _ready() -> void:
	attack.damage = damage

func _process(_delta: float) -> void:
	if do_damage:
		var areas : Array[Area3D] = $Area3D.get_overlapping_areas()
		
		for area in areas:
			if area is HitboxComponent:
				area.damage(attack)
	
