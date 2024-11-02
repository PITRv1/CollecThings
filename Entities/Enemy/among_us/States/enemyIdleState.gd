extends States
class_name enemyIdle

@export var enemy : CharacterBody3D
@export var move_speed := 5.0
var player : CharacterBody3D
@onready var ray: RayCast3D = %RayCast3D

@onready var nav_agent: NavigationAgent3D = %nav_agent
@onready var timer: Timer = %Timer

var looking = true
var move_direction : Vector3
var wander_time : float

func random_wander():
	wander_time = randf_range(6, 8)
	move_direction = Vector3(randf_range(-4, 40), 0.0, randf_range(-4, 40))
	nav_agent.set_target_position(enemy.global_position+move_direction)
	
func Enter(previous_state):
	random_wander()
	player = get_tree().get_first_node_in_group("Player")
	
func Update(delta : float):
	if wander_time > 0:
		wander_time -= delta
	else:
		random_wander()

func Physics_Update(delta : float):
	
	if looking:
		var pos2d : Vector2 = Vector2(enemy.global_position.x, enemy.global_position.z)
		var playerPos2d : Vector2 = Vector2(nav_agent.get_next_path_position().x, nav_agent.get_next_path_position().z)
		var dir = -(pos2d - playerPos2d)
		enemy.rotation.y = lerp_angle(enemy.rotation.y, atan2(dir.x, dir.y), 5 * delta)
	#enemy.look_at(Vector3(player.global_position.x, enemy.global_position.y, player.global_position.z), Vector3.UP)
	
	var destination = nav_agent.get_next_path_position()
	var new_velocity = (destination - enemy.position).normalized() * 2.0
	enemy.velocity = enemy.velocity.move_toward(new_velocity, .25)
	if enemy.global_position.distance_to(player.global_position) < 50.0:
		ray.target_position.z = -enemy.global_position.distance_to(player.global_position)
		ray.look_at(player.global_position, Vector3.UP)
		ray.force_raycast_update()
		var direction = enemy.global_position.direction_to(player.global_position)
		var facing = enemy.global_transform.basis.tdotz(direction)
		var fov = cos(deg_to_rad(30))
		if facing > fov and not ray.is_colliding():
			Transitioned.emit(self, "chase")
	if not enemy.is_on_floor():
		Transitioned.emit(self, "falling")
			
func _on_nav_agemt_navigation_finished() -> void:
	looking = false
	timer.start()

func _on_timer_timeout() -> void:
	looking = true
	random_wander()
	
func Exit():
	pass
