class_name FallingPlayerState

extends PlayerMovementState

func update(_delta)->void:
	if player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("IdlePlayerState")

	if Input.is_action_just_pressed("sprint") and not player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("DashingPlayerState")

	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")
	
	
	
	#if health_component.health <= 0:
		#transition.emit("DeadPlayerState")

	#Jump buffer setup
	if Input.is_action_just_pressed("jump"):
		%JumpBufferTimer.stop()
		player.jump_buffer_running = true
		%JumpBufferTimer.start()
	
	#if Input.is_action_just_pressed("attack"):
		#weapon.attack()
	
func physics_update(delta):
	player.update_gravity(delta)
	player.update_input(delta)
	
	player.update_velocity(delta)
#
	weapon.sway_weapon(delta, false)
