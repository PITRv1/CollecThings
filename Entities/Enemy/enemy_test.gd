extends CharacterBody3D
@onready var player: Player = %Player
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

func _physics_process(delta: float) -> void:
	
	var pos2d = Vector2(position.x, position.z)
	var playerpos2d = Vector2(player.position.x, player.position.z)
	var dir = -(pos2d - playerpos2d)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.y), 1)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		if position.distance_to(player.position) > 2:
			nav_agent.set_target_position(player.position)
			var destination = nav_agent.get_next_path_position()
			var new_velocity = (destination - position).normalized() * 10.0
			velocity = velocity.move_toward(new_velocity, .25)
		else:
			velocity.x = lerp(velocity.x, 0.0, .25)
			velocity.z = lerp(velocity.z, 0.0, .25)
	move_and_slide()
