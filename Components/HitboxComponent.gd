extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var shield_component : ShieldComponent

func damage(attack: WeaponSettings = null, damage: float = 0.0):
	print(attack.damage)
	if health_component:
		if attack:
			if attack.stun_time > 0:
				if "stun_time" in get_parent():
					get_parent().stun_time = attack.stun_time
			
			if shield_component != null:
				if shield_component.shield > attack.damage:
					shield_component.damage(attack)
				elif shield_component.shield < attack.damage:
					var diff : int = int(attack.damage) - int(shield_component.shield)
					
					shield_component.damage(null, shield_component.shield)
					health_component.damage(null, diff)
				else:
					health_component.damage(attack)
			else:
				health_component.damage(attack)
				
		elif damage:
				health_component.damage(null,damage)
				
func heal(amount : int) -> void:
	if health_component:
		health_component.heal(amount)
