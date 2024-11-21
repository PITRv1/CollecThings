extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent

func damage(attack: WeaponSettings = null, damage: float = 0.0):
	if health_component:
		if attack:
			health_component.damage(attack)
		elif damage:
			health_component.damage(null,damage)
