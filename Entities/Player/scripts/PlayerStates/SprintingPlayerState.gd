class_name SprintingPlayerState

extends PlayerMovementState

@export_category("Movement Vars")
@export var movement_speed : float = 11.0
@export var ground_accel := 14.0
@export var ground_decel := 10.0
@export var ground_friction := 6.0

@export_category("Weapon Vars")
@export var weapon_bob_speed : float = 8.0
@export var weapon_bob_h : float = 2.0
@export var weapon_bob_v : float = 1.0

func update(_delta):
	if not Input.is_action_pressed("sprint") and player.is_on_floor() or player._snapped_to_stairs_last_frame:
		transition.emit("WalkingPlayerState")

	if Input.is_action_just_pressed("jump") or player.jump_buffer_running:
		transition.emit("JumpingPlayerState")

	if player.velocity.y < -3:
		transition.emit("FallingPlayerState")
	
	if Input.is_action_just_pressed("_noclip") and OS.has_feature("debug"):
		transition.emit("NoclippingPlayerState")
	
	#if health_component.health <= 0:
		#transition.emit("DeadPlayerState")


func physics_update(delta):
	
	player.current_speed = movement_speed
	player.ground_accel = ground_accel
	player.ground_decel = ground_decel
	player.ground_friction = ground_friction
	
	player.update_gravity(delta)
	player.update_input(delta)
	player.update_velocity(delta)
	
	player.headbob_effect(delta)
	
	weapon.sway_weapon(delta, false)
	weapon.weapon_bob(delta, weapon_bob_speed, weapon_bob_h, weapon_bob_v)
