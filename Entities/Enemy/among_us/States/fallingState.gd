extends States
class_name EnemyFalling

@export var enemy : CharacterBody3D
@onready var audio: AudioStreamPlayer3D = %AudioStreamPlayer3D

var gravity : float
var prev_state : String

func Enter(previous_state):
	print(previous_state)
	prev_state = previous_state
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func Physics_Update(delta : float):
	if not enemy.is_on_floor():
		enemy.velocity.y += -gravity * delta
	else:
		if prev_state.to_lower() != "chase":
			pass
			audio.stop()
		Transitioned.emit(self, prev_state)
