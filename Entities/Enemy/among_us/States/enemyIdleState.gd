extends States
class_name EnemyIdle

@export var enemy : CharacterBody3D
@export var move_speed := 10.0
var player : CharacterBody3D

var move_direction : Vector3
var wander_time : float

func random_wander():
	move_direction = Vector3(randf_range(-1, 1), 0.0, randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	random_wander()
	player = get_tree().get_first_node_in_group("Player")
	
func Update(delta : float):
	if wander_time > 0:
		wander_time -= delta
		
	else:
		random_wander()

func Physics_Update(delta : float):
	
	var pos2d : Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
	var playerPos2d : Vector2 = Vector2(player.global_position.x, player.global_position.z)
	var dir = -(pos2d - playerPos2d)
	enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(dir.x, dir.y), delta / 10)
	
	if enemy:
		enemy.velocity = move_direction * move_speed
		
