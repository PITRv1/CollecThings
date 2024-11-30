extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var shield_component : ShieldComponent


func damage(attack: WeaponSettings = null, damage: float = 0.0):
	if health_component:
		if attack:
			if shield_component != null:
				if shield_component.shield > attack.damage:
					shield_component.damage(attack)
				else:
					health_component.damage(attack)
			else:
				health_component.damage(attack)
				
		elif damage:
				health_component.damage(null,damage)
				
