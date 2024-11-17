class_name DashingPlayerState

extends PlayerMovementState

@export var dash_speed : float = 25.0

@onready var dash_timer: Timer = $DashTimer

func enter(_previous_state)-> void:
	var dash_dir = -player.camera.global_transform.basis.z.normalized()
	
	player.velocity = Vector3.ZERO
	player.velocity.z = dash_dir.z * dash_speed
	player.velocity.x = dash_dir.x * dash_speed
	
	if dash_timer:
		dash_timer.stop()

	dash_timer.start()


#Pls dont fuck with this its 12:00 PM and I want to go to bed. just let me fix it later cause it feels shit

func update(_delta)->void:
	if player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("sprint") and not player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("DashingPlayerState")

	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")

	
func physics_update(delta):
	#player.update_gravity(delta)
	player.update_input(delta)
	
	player.update_velocity(delta)
#
	weapon.sway_weapon(delta, false)

func exit():
	player.velocity = Vector3.ZERO

func _on_dash_timer_timeout() -> void:
	transition.emit("IdlePlayerState")
