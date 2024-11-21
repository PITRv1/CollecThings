class_name DashingPlayerState

extends PlayerMovementState

@export var gravity := 12.0

@export var dashes_left : int = 2
@export var dash_speed : float = 25.0

var dash_cooldown_up : bool = false
var out_of_dashes : bool = false

func enter(_previous_state)-> void:
	dash_cooldown_up = false
	
	if player.dashes_left < 1:
		out_of_dashes = true

		if not %DashCooldown.time_left:
			%DashCooldown.start()
		return


	player.dashes_left -= 1
	var dash_dir = -player.camera.global_transform.basis.z.normalized()
	
	player.velocity = Vector3.ZERO
	player.velocity.z = dash_dir.z * dash_speed
	player.velocity.x = dash_dir.x * dash_speed
	
	if %DashLengthTimer.time_left:
		%DashLengthTimer.stop()

	%DashLengthTimer.start()


func update(_delta)->void:
	if player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("sprint") and not player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("DashingPlayerState")

	if dash_cooldown_up:
		transition.emit("FallingPlayerState")
		
	if out_of_dashes:
		transition.emit("FallingPlayerState")

	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")

	
func physics_update(delta):
	player.gravity = gravity
	
	player.update_input(delta)
	
	player.update_velocity(delta)

	weapon.sway_weapon(delta, false)


func dash_finished() -> void:
	dash_cooldown_up = true
