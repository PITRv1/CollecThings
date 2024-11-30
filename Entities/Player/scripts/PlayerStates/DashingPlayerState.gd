class_name DashingPlayerState

extends PlayerMovementState


@export_category("Movement Vars")
@export var dashes_left : int = 2
@export var dash_speed : float = 25.0

@export var ground_accel := 14.0
@export var ground_decel := 10.0

@export var ground_friction := 0.0

var dash_cooldown_up : bool = false

func enter(_previous_state)-> void:
	dash_cooldown_up = false
	
	if player.dashes_left < 1:
		return

	#Check if we`re dahsing
	if %DashLengthTimer.time_left:
		%DashLengthTimer.stop()
	else:
		%DashLengthTimer.start()

	player.dashes_left -= 1
	
	
	#Calculate & apply direction based on input from player 
	var dash_dir : Vector3
	player.velocity.y = 0
	
	if player.input_dir:
		dash_dir = (player.global_transform.basis * Vector3(player.input_dir.x,0,player.input_dir.y)).normalized()
		player.velocity += dash_dir * dash_speed
		
	else:
		dash_dir = -(player.camera.global_transform.basis.z * Vector3(1,0,1)).normalized()
		player.velocity += dash_dir * dash_speed

func update(_delta)->void:
	if Input.is_action_just_pressed("sprint"):
		transition.emit("DashingPlayerState")
		
	if Input.is_action_just_pressed("jump") and player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("JumpingPlayerState")

	if dash_cooldown_up:
		transition.emit("IdlePlayerState")
		
	if player.dashes_left < 1:
		transition.emit("IdlePlayerState")

	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")

func physics_update(delta):
	player.ground_friction = ground_friction
	player.ground_accel = ground_accel
	player.ground_decel = ground_decel
	
	player.update_gravity(delta)
	player.update_input(delta)
	
	player.update_velocity(delta)

	weapon.sway_weapon(delta, false)


func dash_finished() -> void:
	dash_cooldown_up = true
