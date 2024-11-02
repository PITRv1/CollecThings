extends States
class_name EnemyTest

@export var enemy : CharacterBody3D
var player : CharacterBody3D
@onready var ray: RayCast3D = %RayCast3D

func Enter(previous_state):
	player = get_tree().get_first_node_in_group("Player")
	
func Physics_Update(delta : float):
	if enemy.global_position.distance_to(player.global_position) < 50.0:
		ray.target_position.z = -enemy.global_position.distance_to(player.global_position)
		ray.look_at(player.global_position, Vector3.UP)
		ray.force_raycast_update()
		var direction = enemy.global_position.direction_to(player.global_position)
		var facing = enemy.global_transform.basis.tdotz(direction)
		var fov = cos(deg_to_rad(60))
		if ray.is_colliding():
			print(ray.get_collider())
		if facing > fov and  not ray.is_colliding():
			print("I hate Ni...")
			#Transitioned.emit(self, "chase")
		else:
			print("I kann nicht du sehen")
