class_name IdlePlayerState

extends PlayerMovementState

@export var gravity := 12.0

func update(_delta)->void:
	if $"../..".paused: return
	
	if player.velocity.length() > 0.0 and player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("WalkingPlayerState")
		
	if (Input.is_action_just_pressed("jump") or player.jump_buffer_running) and (player.is_on_floor() or player._snapped_to_stairs_last_frame):
		transition.emit("JumpingPlayerState")
	
	if player.velocity.y < -3:
		transition.emit("FallingPlayerState")
		
	if Input.is_action_just_pressed("sprint") and not %DashTimeout.time_left:
		transition.emit("DashingPlayerState")

	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")



func physics_update(delta):
	player.gravity = gravity
	
	player.update_gravity(delta)
	player.update_input(delta)
	
	player.update_velocity(delta)


	weapon.sway_weapon(delta, true)
