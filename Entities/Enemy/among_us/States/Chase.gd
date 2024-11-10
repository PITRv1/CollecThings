extends States
class_name EnemyChase

@export var enemy : CharacterBody3D
var player : CharacterBody3D
@onready var audio: AudioStreamPlayer3D = %AudioStreamPlayer3D

@onready var nav_agent: NavigationAgent3D = %nav_agent

func Enter(previous_state):
	if previous_state != "falling":
		audio.play()
	player = get_tree().get_first_node_in_group("Player")
	nav_agent.set_target_position(player.global_position)
	

func Physics_Update(delta : float):
	
	nav_agent.set_target_position(player.global_position)
	var pos2d : Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
	var playerPos2d : Vector2 = Vector2(nav_agent.get_next_path_position().x, nav_agent.get_next_path_position().z)
	var dir = -(pos2d - playerPos2d)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(dir.x, dir.y), 5 * delta)
	#enemy.look_at(Vector3(player.global_position.x, enemy.global_position.y, player.global_position.z), Vector3.UP)
	
	var destination = nav_agent.get_next_path_position()
	var new_velocity = (destination - enemy.position).normalized() * 20.0
	enemy.velocity = enemy.velocity.move_toward(new_velocity, .25)
	
	if not enemy.is_on_floor():
		Transitioned.emit(self, "falling")
