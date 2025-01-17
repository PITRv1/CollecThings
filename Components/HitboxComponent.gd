extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent
@export var shield_component : ShieldComponent

func damage(attack: WeaponSettings = null):
	if health_component:
		if attack:
			if attack.stun_time > 0:
				if "stun_time" in get_parent():
					get_parent().stun_time = attack.stun_time
			
			if shield_component:
				if shield_component.shield > attack.damage:
					shield_component.damage(attack.damage)
				
				elif shield_component.shield < attack.damage:
					var diff : int = int(attack.damage) - int(shield_component.shield)
					
					shield_component.damage(shield_component.shield)
					health_component.damage(diff)
				else:
					health_component.damage(attack.damage)
			else:
				health_component.damage(attack.damage)
				
	


func heal(amount : int) -> void:
	if health_component:
		health_component.heal(amount)
