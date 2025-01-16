extends BaseWeapon

# The bullet hole
@export var b_decal : PackedScene = preload("res://Assets/Models/Bullet/BulletDecal.tscn")

# Things we change in the code
@onready var handle: MeshInstance3D = $Shotgun/Kurbli
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var hook_start_position: Node3D = $Shotgun/hook_start_position
@onready var hook: MeshInstance3D = $Shotgun/hook
@onready var hook_raycast: RayCast3D = $Shotgun/hook/RayCast3D
@onready var helper_cast: RayCast3D = $HelperCast
@onready var hook_rope_gen: MeshInstance3D = $RopeGen
@onready var remote_transform := RemoteTransform3D.new()
@export_enum("Pulls player", "Constant distance") var grapple_type: int = 0
@export var GRAPPLE_RAY_MAX : float = 30.0
@export var GRAPPLE_FORCE_MAX : float = 20.0
@export var hook_speed : float = 30.0

# States
var is_enemy_grapple := false
var is_grappling : bool
var rope_go := false
var rope_go_back := false
var base_state := true

# Global variables
var pos : Vector3
var ini_rot : Vector3
var helper : Vector3
var ini_pos : Vector3
var enemy
var charge := 0.0

# If this is true, it pulls normal enemies towards the player
@export var is_enemy_grapple_enabled := false

# This is for the constant distance grapple
@export var rest_length := 2.0
@export var stiffness = 10.0
@export var dampning = 1.0

# Also for UI
@onready var gun_utility : Polygon2D = get_tree().get_first_node_in_group("gun_utility")

func _ready() -> void:
	gun_utility.set_texture_offset(Vector2(10, 0))
	hook_rope_gen.visible = false
	hook.global_position = hook_start_position.global_position
	mag_size = weapon_settings.mag_size
	ini_rot = self.rotation
	max_mag_size = weapon_settings.mag_size

func _physics_process(delta: float) -> void:
	
	# I know this looks ass but I'm pretty sure it's needed, basically if nothing is happening you can charge the grappler
	# If nothing is happening you can charge the grappler
	
	check_for_colliding()
	
	if Input.is_action_pressed("secondary_fire") and charge <= 5 and not animation_player.is_playing() and base_state:
		# Adds 2 charge every second, change the 2, to make it faster or slower
		# haha I've found a grammer mistake you dumbass
		charge += delta * 2
		is_primary_enabled = false
		
		# Handle rotates while holding the alt fire
		handle.rotation.x += -5 * delta
		
		# Some stupid ahh UI thing, It's really smart tho
		# I swear to god I will transform your balls into nothing
		gun_utility.set_texture_offset(Vector2(5-(charge*2), 0))
	
	# If alt fire is released the grappler is sent back to the starting point
	# The animation thing there is to make sure we ain't reloading
	elif Input.is_action_just_released("secondary_fire") and not animation_player.is_playing():
		
		# pos is the end position, this is where the grappler will go, and look at, if nothing is in the way
		var camera : Camera3D = get_viewport().get_camera_3d()
		pos = camera.global_position + camera.global_transform.basis.z * -GRAPPLE_RAY_MAX * charge / 5
		var pos_ray = run_hook_ray(GRAPPLE_RAY_MAX * charge / 5)
		if pos_ray.size() > 0:
			
			pos = pos_ray["position"]
		
		# If the charge is less than 1, basically do nothing
		if charge <= 1:
			charge = 0
			
			# Just a normal tween that returns the Handle rotation to 0.0 in .1 sec
			var t : Tween = get_tree().create_tween()
			t.tween_property(handle, "rotation", Vector3(0.0, 0.0, 0.0), 0.1)
			t.kill()
			
			# Also a just in case thing
			handle.rotation.x = 0.0
		
		# If is the base state, send the grapple on it's way
		elif base_state:
			base_state = false
			
			hook_raycast.look_at(pos)
			
			# For the rope mesh, don't worry about it
			hook_rope_gen.SetPlayerPosition(player.global_position)
			hook_rope_gen.SetGrappleHookPosition(hook.global_position)
			hook_rope_gen.StartDrawing()
			
			is_primary_enabled = true
			rope_go = true
			
		else:
			# If remote transform is a thing, delete it
			if is_instance_valid(remote_transform):
				remote_transform.queue_free()
				remote_transform = RemoteTransform3D.new()
			else:
				remote_transform = RemoteTransform3D.new()
			
			# Starts the return process of the grappler
			is_enemy_grapple = false
			is_grappling = false
			rope_go = false
			rope_go_back = true
			
		
	# Rope launching state
	if rope_go:
		hook.top_level = true
		
		# Make the grappler look at the target
		hook.look_at(pos)
		hook_raycast.look_at(pos)
		
		# Update grappler position, also update the target position of the raycast to compensate for the speed of the grappler
		hook.global_position += hook.global_basis * Vector3.FORWARD * hook_speed * delta
		hook_raycast.target_position = Vector3.FORWARD * hook_speed * delta * 5.0
		#hook.global_position = lerp(hook.global_position, pos, hook_speed * delta)
		
		# Rotate the handle to 0.0
		handle.rotation.x = lerp(handle.rotation.x, 0.0, hook_speed * delta/hook.global_position.distance_to(pos))
		hook_rope_gen.visible = true
		
		# Used for the rope mesh creation
		hook_rope_gen.SetPlayerPosition(hook_start_position.global_position)
		hook_rope_gen.SetGrappleHookPosition(hook.global_position)
		
		hook_raycast.force_raycast_update()
		
		if hook_raycast.is_colliding():
			
			# Just to make sure, have the grappler equal the raycast collision point and make the handle rotation 0.0
			hook.global_position = hook_raycast.get_collision_point()
			handle.rotation.x = 0.0
			
			# Used for the constant distance grappler
			helper = player.global_position
			
			# If the thing the raycast collides with is an enemy, also if the enemy_grapple bool is set to true
			if hook_raycast.get_collider().is_in_group("enemy") and is_enemy_grapple_enabled:
				
				# Save the enemy as a variable for later use, also set up the remote_transform
				enemy = hook_raycast.get_collider()
				remote_transform = RemoteTransform3D.new()
				enemy.add_child(remote_transform)
				
				remote_transform.global_transform = hook.global_transform
				remote_transform.remote_path = remote_transform.get_path_to(hook)
				remote_transform.use_global_coordinates = true
				
				# Set up the states
				is_enemy_grapple = true
				rope_go = false
				
			else:
				is_grappling = true
				rope_go = false
				
				# Again used for constant distance rope
				rest_length = player.global_position.distance_to(hook.global_position)
				
		
		# If the grappler reaches the end minus 2 meters, it goes back to the starting position
		elif hook.global_position.distance_to(pos) <= 2:
			rope_go = false
			rope_go_back = true
			
		else:
			gun_utility.set_texture_offset(Vector2(5, 0))
			
	# Grappling to an enemy, uses RemoteTransfomr3D, for some reason needs a 0.1 sec timeout to work, not sure why
	# Sidenote please Peti look into this, I literally have no clue why it needs to be like this
	if is_enemy_grapple:
		hook.top_level = true
		hook.top_level = true
		
		rope_go = false
		rope_go_back = false
		
		hook_rope_gen.SetPlayerPosition(hook_start_position.global_position)
		hook_rope_gen.SetGrappleHookPosition(hook.global_position)
			
		var grapple_dir = (player.global_position - enemy.global_position).normalized()
		var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX * 8
		var grapple_dif = (grapple_target_speed - enemy.velocity)
		
		enemy.velocity += grapple_dif * delta
		
		if player.global_position.distance_to(hook.global_position) < 4:
			is_enemy_grapple = false
			
			remote_transform.force_update_cache()
			remote_transform.queue_free()
			await get_tree().create_timer(0.2).timeout
			
			is_grappling = false
			rope_go = false
			rope_go_back = true
	
	
	# Grappling to a non enemy
	if is_grappling:
		
		hook.top_level = true
		rope_go = false
		rope_go_back = false
		
		hook_rope_gen.SetPlayerPosition(hook_start_position.global_position)
		hook_rope_gen.SetGrappleHookPosition(hook.global_position)
		gun_utility.set_texture_offset(Vector2(5, 0))
		
		# grapple type 0 is just a basic vector to the grapple point
		if grapple_type == 0:
			
			var grapple_dir = (hook.global_position - player.global_position).normalized()
			var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX * 5
			var grapple_dif = (grapple_target_speed - player.velocity)
				
			player.velocity += grapple_dif * delta
			
		if player.global_position.distance_to(hook.global_position) < 3:
			
			is_grappling = false
			rope_go_back = true
			gun_utility.set_texture_offset(Vector2(5, 0))

	# Rope going back to starting point state
	if rope_go_back:
		helper_cast.target_position.z = 0
		player.crosshair.change_crosshair_color(Color.WHITE)
		hook.top_level = true
		hook_rope_gen.visible = true
		
		hook_rope_gen.SetPlayerPosition(hook_start_position.global_position)
		hook_rope_gen.SetGrappleHookPosition(hook.global_position)
		
		hook.global_position = hook.global_position.move_toward(hook_start_position.global_position, delta*hook_speed)
		hook.rotation = hook.rotation.move_toward(hook_start_position.rotation, delta*hook_speed)
		
		if hook.global_position.is_equal_approx(hook_start_position.global_position):
			
			hook.top_level = false
			hook_rope_gen.visible = false
			is_grappling = false
			rope_go_back = false
			base_state = true
			
			charge = 0.0
			hook.rotation = Vector3(0, 0, 0)
	
# A second type of grappling, tries to keep a constant distance between the grapple point and the player

	if is_grappling and grapple_type == 1:
		
		var target_dir = player.global_position.direction_to(hook.global_position)
		var target_dist = player.global_position.distance_to(hook.global_position)
		var displacement = target_dist - rest_length
		var input_dir = Input.get_vector("left", "right", "up", "down").normalized()
		var force = Vector3.ZERO
		
		if displacement > 0:
			
			var spring_force_magnitude = stiffness * displacement
			var spring_force = target_dir * spring_force_magnitude
			var vel_dot = player.velocity.dot(target_dir)
			var damping = -dampning * vel_dot * target_dir
			
			force = spring_force + damping
		
		if input_dir.y == -1:
			force += Vector3.FORWARD * 1
			
		player.velocity += force * delta

func check_for_colliding():
	if charge < 1: return
	
	if run_hook_ray(GRAPPLE_RAY_MAX * charge).size() > 0:
		player.crosshair.change_crosshair_color(Color.YELLOW)
	else:
		player.crosshair.change_crosshair_color(Color.WHITE)
		
func run_hook_ray(length):
	# Project ray
	var camera = get_viewport().get_camera_3d()
	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()
	var dot_pos = player.crosshair.position
	mousepos = dot_pos
	var from = camera.project_ray_origin(mousepos)
	
	var to = from + camera.project_ray_normal(mousepos) * length
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	return space_state.intersect_ray(query)
