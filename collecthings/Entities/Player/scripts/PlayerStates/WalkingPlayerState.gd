class_name WalkingPlayerState

extends PlayerMovementState
 
@export var weapon_bob_speed : float = 6.0
@export var weapon_bob_h : float = 2.0
@export var weapon_bob_v : float = 1.0

func update(delta):
	if player.velocity.length() == 0.0 and player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("IdlePlayerState")

	if Input.is_action_just_pressed("jump") or player.jump_buffer_running:
		transition.emit("JumpingPlayerState")

	if player.velocity.y < -3:
		transition.emit("FallingPlayerState")
	
	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")
	
	#if health_component.health <= 0:
		#transition.emit("DeadPlayerState")
	
	#if Input.is_action_just_pressed("attack"):
		#weapon.attack()

func physics_update(delta):	
	player.update_gravity(delta)
	player.update_input(delta)
	player.update_velocity(delta)
	
	player.headbob_effect(delta)
	
	#weapon.sway_weapon(delta, false)
	#weapon.weapon_bob(delta, weapon_bob_speed, weapon_bob_h, weapon_bob_v)
