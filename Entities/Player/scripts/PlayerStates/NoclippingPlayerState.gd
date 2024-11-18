class_name NoclippingPlayerState

extends PlayerMovementState

var noclip_speed_mult : float
var cam_aligned_wish_dir : Vector3
var input_dir : Vector2

func enter(_previous_state):
	%DashLengthTimer.stop()
	%DashCooldown.stop()
	
	noclip_speed_mult = 3.0
	%PlayerCollisionShape.disabled = true

func exit():
	%PlayerCollisionShape.disabled = false

func update(_delta):
	if Input.is_action_just_pressed("_noclip"):
		transition.emit("IdlePlayerState")


func physics_update(delta):
	input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	cam_aligned_wish_dir = %Camera3D.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	var speed = 10.0 * noclip_speed_mult
	if Input.is_action_pressed("sprint"):
		speed *= 3.0
	
	player.velocity = cam_aligned_wish_dir * speed
	player.global_position += player.velocity * delta


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			noclip_speed_mult = min(100.0, noclip_speed_mult * 1.1)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			noclip_speed_mult = max(0.1, noclip_speed_mult * 0.9)
