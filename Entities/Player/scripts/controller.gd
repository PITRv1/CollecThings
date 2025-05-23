class_name Player 
extends CharacterBody3D

@export_category("Camera")
@export var head_tilt_amount : float = 1.5
@export var BASE_FOV := 80.0
@export var FOV_CHANGE := 1.0

@export_category("Player Resources")
@export var weapon_controller : WeaponController
@export var health_component : HealthComponent
@export var shield_component : ShieldComponent

@onready var camera : Camera3D = %Camera3D


#Needed for no UI in mid level cutscenes
@onready var ui: Node3D = $Head/CameraSmooth/Camera3D/Ui

########################################################
#Saved inputs and directions
var input_dir := Vector2.ZERO
var wish_dir := Vector3.ZERO

#Movement variables set by states
var gravity := 12.0

var current_speed := 9.0
var ground_accel := 14.0
var ground_decel := 10.0
var ground_friction := 6.0

var dashes_left := 2

#Slide variable
const SLIDE_TRANSLATE := 0.5
var sliding := false
var slide_friction := 3.0
var stand_to_slide := Vector3.ZERO
var input_to_slide := Vector3.ZERO

#Headbob variables
const headbob_move_amount := 0.06 # side to side
const headbob_frequency := 1.4 # how fast is side to side
var headbob_time := 0.0

#Stair movment variables
const MAX_STEP_HEIGHT := 0.5
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF

@onready var stairs_ahead_raycast: RayCast3D = $StairsAheadRayCast
@onready var stairs_below_raycast: RayCast3D = $StairsBelowRayCast

@onready var hitbox_component : HitboxComponent = $HitboxComponent
@onready var damage_heal_effect: TextureRect = $Head/CameraSmooth/Camera3D/Damage_Heal_effect

@export var safe_mode : SafeMode
@export var crosshair : CenterContainer
@export var inventory : Dictionary = {}


#Jump buffer && (maybe coyoteTime) variables
var jump_buffer_running := false
var look_sensitivity := 0.003
var paused : bool = false

########################################################

func _input(event):
	if paused: return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		%Camera3D.rotate_x(-event.relative.y * look_sensitivity)
		%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	
	if Input.is_action_just_pressed("hide_ui"):
		if ui.visible:
			ui.visible = false
			crosshair.visible = false
			weapon_controller.visible = false
		else:
			ui.visible = true
			crosshair.visible = true
			weapon_controller.visible = true
			
			
	

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player = self
	dashes_left = %DashingPlayerState.dashes_left
	
	health_component.healed.connect(on_healed)
	health_component.damaged.connect(on_damaged)
	shield_component.damaged.connect(on_shield_damaged)
	
	
	

########################################################

#region Camera effets ------ Smoothing ## Tilting ## Bobing
func fov_change(delta):
	var velocity_clamped = clamp(velocity.length(), 0.5, 20)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 5.0)

var _saved_camera_global_pos = null
func _save_camera_pos_for_smoothing():
	if _saved_camera_global_pos == null:
		_saved_camera_global_pos = %CameraSmooth.global_position

func _slide_camera_smooth_back_to_origin(delta):
	if _saved_camera_global_pos == null: return
	%CameraSmooth.global_position.y = _saved_camera_global_pos.y
	%CameraSmooth.position.y = clampf(%CameraSmooth.position.y, -0.7,0.7) # Clamp incase teleported
	var move_amount = max(self.velocity.length() * delta, current_speed/2 * delta)
	%CameraSmooth.position.y = move_toward(%CameraSmooth.position.y, 0.0, move_amount)
	_saved_camera_global_pos = %CameraSmooth.global_position
	if %CameraSmooth.position.y == 0:
		_saved_camera_global_pos = null # Stop smoothing camera

func cam_tilt_effect():
	if input_dir.x > 0:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(-head_tilt_amount), 0.05)
	elif input_dir.x < 0:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(head_tilt_amount), 0.05)
	else:
		%Head.rotation.z = lerp_angle(%Head.rotation.z, deg_to_rad(0), 0.05)
	
func headbob_effect(delta):
	headbob_time += delta * velocity.length()
	%Camera3D.transform.origin = Vector3(
		cos(headbob_time * headbob_frequency * 0.5) * headbob_move_amount,
		sin(headbob_time * headbob_frequency) * headbob_move_amount,
		0
	)

#endregion

#region Stairs && Slope checks && Movement

func is_surface_too_steep(normal : Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	stairs_below_raycast.force_raycast_update()
	var floor_below : bool = stairs_below_raycast.is_colliding() and not is_surface_too_steep(stairs_below_raycast.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = KinematicCollision3D.new()
		if self.test_move(self.global_transform, Vector3(0,-MAX_STEP_HEIGHT,0), body_test_result):
			_save_camera_pos_for_smoothing()
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false

	if self.velocity.y > 0 or (self.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))

	var down_check_result = KinematicCollision3D.new()
	if (self.test_move(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2,0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y

		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - self.global_position).y > MAX_STEP_HEIGHT: return false
		stairs_ahead_raycast.global_position = down_check_result.get_position() + Vector3(0,MAX_STEP_HEIGHT,0) + expected_move_motion.normalized() * 0.1
		stairs_ahead_raycast.force_raycast_update()
		if stairs_ahead_raycast.is_colliding() and not is_surface_too_steep(stairs_ahead_raycast.get_collision_normal()):
			_save_camera_pos_for_smoothing()
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
#endregion

########################################################

#region Slide Stuff
#@onready var _original_capsule_height = $CollisionShape3D.shape.height
#func _handle_slide(delta):
	#if Input.is_action_pressed("crouch") and (is_on_floor() or _snapped_to_stairs_last_frame):
		#sliding = true
		#
	#elif sliding and (not self.test_move(self.transform, Vector3(0, SLIDE_TRANSLATE, 0)) or %CrouchCollideRayCast.is_colliding()):
		#sliding = false
		#stand_to_slide = Vector3.ZERO 
		#input_to_slide = Vector3.ZERO
#
#
	#if sliding:
		#slide_speed_change(stand_to_slide, delta)
#
	#%Head.position.y = move_toward(%Head.position.y, -SLIDE_TRANSLATE if sliding else 0.0, 6.0 * delta )
	#$CollisionShape3D.shape.height = (_original_capsule_height - SLIDE_TRANSLATE) if sliding else _original_capsule_height
	#$CollisionShape3D.position.y = $CollisionShape3D.shape.height / 2 
	#
#func save_player_orientation_for_slide()->void:
	#stand_to_slide = -self.transform.basis.z 
	#input_to_slide = self.global_transform.basis * Vector3(input_dir.x,0,input_dir.y)
#
#func slide_speed_change(direction:Vector3, delta: float)-> void:
	#var current_vel = self.velocity.length()
	#var add_speed_till_cap = slide_speed - current_vel
	#
	#if add_speed_till_cap > 0:
		#var accel_speed = ground_accel * delta * slide_speed
		#self.velocity += accel_speed * direction
		#
	#friction(slide_speed, 1.0, delta)
#endregion

############-----Player PHYSICS-----###############

func friction(target_speed, applied_friction, delta:float)->void:
	var control = max(self.velocity.length(), ground_decel)
	var drop = control * applied_friction * delta
	var new_speed = max(self.velocity.length() - drop, target_speed)
	if self.velocity.length() > 0:
		new_speed /= self.velocity.length()
	self.velocity *= new_speed

func _handle_ground_physics(delta: float) -> void:
	dashes_left = %DashingPlayerState.dashes_left
	
	var add_speed_till_cap = current_speed - Vector3(self.velocity.x, 0, self.velocity.z).length()
	
	if add_speed_till_cap > 0:
		var accel_speed = ground_accel * delta * current_speed
		self.velocity += accel_speed * wish_dir
	
	friction(0.0, ground_friction, delta)

func _handle_air_physics(delta: float) -> void:
	var add_speed_till_cap = (current_speed/ 2) - Vector3(self.velocity.x, 0, self.velocity.z).length()
	var current_velocity_direction = Vector3(self.velocity.x, 0, self.velocity.z).normalized()

	var dot_product = wish_dir.normalized().dot(current_velocity_direction)

	var new_speed = (ground_accel / 7) * delta * current_speed

	if add_speed_till_cap > 0 or dot_product < 0:
		self.velocity += new_speed * wish_dir.normalized()

####################################################

var screen_effect_intensity : float
var screen_effect_color : Color

var target_screen_effect_intensity : float

func _process(delta: float) -> void:
	#screen_effect_intensity = target_screen_effect_intensity
	if health_component.health <= health_component.MAX_HEALTH / 4.0:
		screen_effect_intensity = lerp(screen_effect_intensity, 0.5, delta)
	else:
		screen_effect_intensity = lerp(screen_effect_intensity, 0.0, delta)
		
	
	damage_heal_effect.material.set_shader_parameter("intensity", screen_effect_intensity)
	damage_heal_effect.material.set_shader_parameter("vignette_color", screen_effect_color)

#Updating always on functions
func _physics_process(delta):
	if is_on_floor(): 
		_last_frame_was_on_floor = Engine.get_physics_frames()
	
	cam_tilt_effect()
	fov_change(delta)

#Callables for the movement states
func update_gravity(delta):
	self.velocity.y -= gravity * delta 

func update_input(delta):
	if paused: return
	
	input_dir = Input.get_vector("left", "right", "up", "down").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)
	
	if is_on_floor() or _snapped_to_stairs_last_frame:
		_handle_ground_physics(delta)
	else:
		_handle_air_physics(delta)

func update_velocity(delta):
	if not _snap_up_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()
	
	_slide_camera_smooth_back_to_origin(delta)


func _on_jump_buffer_timer_timeout() -> void:
	jump_buffer_running = false


@export_group("Damage & Healed stage Colors")
@export_color_no_alpha var hp_damaged_color : Color
@export_color_no_alpha var hp_healed_color : Color
@export_color_no_alpha var shield_damaged_color : Color
func on_healed():
	screen_effect_intensity = 1.0
	screen_effect_color = hp_healed_color

func on_damaged():
	screen_effect_intensity = 1.0
	screen_effect_color = hp_damaged_color


	damage_heal_effect.material.set_shader_parameter("vignette_color", Vector3(255,0,0))


func on_shield_damaged():
	screen_effect_intensity = 1.0
	screen_effect_color = shield_damaged_color
