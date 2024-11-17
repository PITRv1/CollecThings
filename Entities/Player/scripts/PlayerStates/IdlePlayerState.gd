class_name IdlePlayerState

extends PlayerMovementState

func update(_delta)->void:
	if player.velocity.length() > 0.0 and player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_just_pressed("jump") or player.jump_buffer_running:
		transition.emit("JumpingPlayerState")
	
	if player.velocity.y < -3:
		transition.emit("FallingPlayerState")
		
	if Input.is_action_just_pressed("sprint") and not player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("DashingPlayerState")

	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")



func physics_update(delta):
	player.update_gravity(delta)
	player.update_input(delta)
	
	player.update_velocity(delta)


	weapon.sway_weapon(delta, true)
