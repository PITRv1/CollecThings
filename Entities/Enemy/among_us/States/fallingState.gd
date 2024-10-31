extends States
class_name EnemyFalling

@export var enemy : CharacterBody3D

var gravity : float

func Enter():	
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Physics_Update(delta : float):
	if not enemy.is_on_floor():
		enemy.velocity.y += -gravity * delta
		
	else:
		
		Transitioned.emit(self, "idle")
