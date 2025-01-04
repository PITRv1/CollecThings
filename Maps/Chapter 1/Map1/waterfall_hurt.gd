extends Area3D

@export var damage : float = 1.0

var attack := WeaponSettings.new()

func _ready() -> void:
	attack.damage = damage

func _process(_delta: float) -> void:
	var areas : Array[Area3D] = self.get_overlapping_areas()
	
	for area: HitboxComponent in areas:
		area.damage(attack)
	
	
