extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var shield_component : ShieldComponent

func damage(attack: WeaponSettings = null, damage: float = 0.0):
	if health_component:
		if attack:
			print("attack stun: ", attack.stun_time)
			if attack.stun_time > 0:
				if "stun_time" in get_parent():
					get_parent().stun_time = attack.stun_time
			if shield_component != null:
				if shield_component.shield > attack.damage:
					shield_component.damage(attack)
				else:
					health_component.damage(attack)
			else:
				health_component.damage(attack)
				
		elif damage:
				health_component.damage(null,damage)
