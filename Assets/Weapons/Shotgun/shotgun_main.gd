extends  BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/BulletDecal.tscn")
@onready var kurbli: MeshInstance3D = $Shotgun/Kurbli
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var rope_gen: MeshInstance3D = $RopeGen
@onready var alma: Node3D = $Shotgun/alma_pos
@onready var alma_end: MeshInstance3D = $Shotgun/alma
@onready var roycast: RayCast3D = $Shotgun/alma/RayCast3D
@onready var remote_transform := RemoteTransform3D.new()
@export_enum("Pulls player", "Constant distance") var grapple_type: int = 0
@export var GRAPPLE_RAY_MAX : float = 30.0
@export var GRAPPLE_FORCE_MAX : float = 20.0
@export var alma_speed := 30.0
@onready var prev_pos
var grapple_anchor
var ray
var is_enemy_grapple := false
var t
var grapple_raycast_hit
var grapple_hook_position
var is_grappling : bool
var charge := 0.0
var rope_go := false
var rope_go_back := false
var pos
var ini_rot
var helper
var start := false
var ini_pos
var enemy
@export var is_enemy_grapple_enabled := false
@export var bald_speed : float = 5

@export var rest_length := 2.0
@export var stiffness = 10.0
@export var dampning = 1.0

@onready var gun_utility = get_tree().get_first_node_in_group("gun_utility")
@onready var hook: Node3D = $Shotgun/alma

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	rope_gen.visible = false
	alma_end.global_position = alma.global_position
	clips = weapon_settings.mag_size
	ini_rot = self.rotation
	prev_pos = player.transform.origin
	max_clips = weapon_settings.mag_size

#func _process(delta: float) -> void:
	#if Input.is_action_pressed("secondary_fire") and not rope_go_back and not rope_go:
		#
		#charge += delta
		#kurbli.rotation.x += -5 * delta
			#
	#elif Input.is_action_just_released("secondary_fire") and not rope_go:
		#var camera = get_viewport().get_camera_3d()
		#pos = camera.global_position + camera.global_transform.basis.z * -GRAPPLE_RAY_MAX * charge
		#if not rope_go and not rope_go_back and not is_grappling:
			#roycast.look_at(pos)
			#rope_gen.SetPlayerPosition(player.global_position)
			#rope_gen.SetGrappleHookPosition(alma_end.global_position)
			#rope_gen.StartDrawing()
			#rope_go = true
		#else:
			#remote_transform.queue_free()
			#remote_transform = RemoteTransform3D.new()
			#is_grappling = false
			#rope_go = false
			#rope_go_back = true
	#if rope_go:
		#alma_end.top_level = true
		#t = get_tree().create_tween()
		#t.tween_property(alma_end, "global_position", pos, alma_end.global_position.distance_to(pos)/alma_speed)
		#self.look_at(alma_end.global_position)
		#rope_gen.visible = true
		#rope_gen.SetPlayerPosition(alma.global_position)
		#rope_gen.SetGrappleHookPosition(alma_end.global_position)
		#roycast.force_raycast_update()
		#if roycast.is_colliding():
			#t.kill()
			#print("apple")
			#print(t)
			#helper = alma_end.global_position
			#is_grappling = true
			#rope_go = false
		#elif alma_end.global_position == pos:
			#rope_go = false
			#rope_go_back = true
		#
	#if is_grappling:
		#if roycast.is_colliding():
			#alma_end.top_level = true
			#roycast.get_collider().add_child(remote_transform)
			#remote_transform.global_transform = alma_end.global_transform
			#remote_transform.remote_path = remote_transform.get_path_to(alma_end)
		#alma_end.top_level = true
		#rope_go = false
		#rope_go_back = false
		#self.look_at(alma_end.global_position)
		#rope_gen.SetPlayerPosition(alma.global_position)
		#rope_gen.SetGrappleHookPosition(alma_end.global_position)
		#if grapple_type == 0:
			#var grapple_dir = (alma_end.global_position - player.global_position).normalized()
			#var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX * 5
				#
			#var grapple_dif = (grapple_target_speed - player.velocity)
				#
			#player.velocity += grapple_dif * delta
		#if player.global_position.distance_to(alma_end.global_position) < 3:
			#is_grappling = false
			#rope_go_back = true
#
	#if rope_go_back:
		#alma_end.top_level = true
		#rope_gen.visible = true
		#self.rotation = ini_rot
		#rope_gen.SetPlayerPosition(alma.global_position)
		#rope_gen.SetGrappleHookPosition(alma_end.global_position)
		#alma_end.global_position = alma_end.global_position.move_toward(alma.global_position, delta*10)
		#if alma_end.global_position == alma.global_position:
			#alma_end.top_level = false
			#charge = 0.0
			#rope_go_back = false


		
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("secondary_fire") and not rope_go_back and not rope_go and charge <= 5 and not animation_player.is_playing() and not is_enemy_grapple and not is_grappling:
		
		print(charge)
		charge += delta * 2
		kurbli.rotation.x += -5 * delta
		gun_utility.set_texture_offset(Vector2(10-(charge*2), 0))
		
	if Input.is_action_just_pressed("sprint"):
		print(kurbli.rotation.x)
		print(alma_end.global_position, alma.global_position)
		print(clips)
		if enemy:
			print("what")
			print(enemy.children)
			
	elif Input.is_action_just_released("secondary_fire") and not rope_go and not animation_player.is_playing():
		var camera = get_viewport().get_camera_3d()
		pos = camera.global_position + camera.global_transform.basis.z * -GRAPPLE_RAY_MAX * charge / 5
		if charge <= 1:
			charge = 0
			var t = get_tree().create_tween()
			t.tween_property(kurbli, "rotation", Vector3(0.0, 0.0, 0.0), 0.1)
			t.kill()
			kurbli.rotation.x = 0.0
		elif not rope_go and not rope_go_back and not is_grappling and not is_enemy_grapple:
			roycast.look_at(pos)
			rope_gen.SetPlayerPosition(player.global_position)
			rope_gen.SetGrappleHookPosition(alma_end.global_position)
			rope_gen.StartDrawing()
			rope_go = true
		else:
			if is_instance_valid(remote_transform):
				remote_transform.queue_free()
				remote_transform = RemoteTransform3D.new()
			else:
				remote_transform = RemoteTransform3D.new()
			is_enemy_grapple = false
			is_grappling = false
			rope_go = false
			rope_go_back = true
			start = false
		
		gun_utility.set_texture_offset(Vector2(0, 0))
		
		
	if rope_go:
		print("rope_go")
		alma_end.top_level = true
		alma_end.look_at(pos)
		roycast.look_at(pos)
		alma_end.global_position += alma_end.global_basis * Vector3.FORWARD * alma_speed * delta
		roycast.target_position = Vector3.FORWARD * alma_speed * delta * 5.0
		kurbli.rotation.x = lerp(kurbli.rotation.x, 0.0, alma_speed * delta/alma_end.global_position.distance_to(pos))
		rope_gen.visible = true
		rope_gen.SetPlayerPosition(alma.global_position)
		rope_gen.SetGrappleHookPosition(alma_end.global_position)
		roycast.force_raycast_update()
		if roycast.is_colliding():
			alma_end.global_position = roycast.get_collision_point()
			kurbli.rotation.x = 0.0
			print("apple")
			helper = player.global_position
			if roycast.get_collider().is_in_group("enemy") and is_enemy_grapple_enabled:
				enemy = roycast.get_collider()
				enemy.add_child(remote_transform)
				is_enemy_grapple = true
				rope_go = false
				start = false
			else:
				start = true
				is_grappling = true
				rope_go = false
				rest_length = player.global_position.distance_to(alma_end.global_position)
		elif alma_end.global_position.distance_to(pos) <= 2:
			rope_go = false
			rope_go_back = true
			start = false
			
	if is_enemy_grapple:
		if roycast.is_colliding():
			
			alma_end.top_level = true
			
			remote_transform.global_transform = alma_end.global_transform
			remote_transform.remote_path = remote_transform.get_path_to(alma_end)
			alma_end.top_level = true
			rope_go = false
			rope_go_back = false
			rope_gen.SetPlayerPosition(alma.global_position)
			rope_gen.SetGrappleHookPosition(alma_end.global_position)
			
			#var grapple_dir = (player.global_position - enemy.global_position).normalized()
			#var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX * 8
					#
			#var grapple_dif = (grapple_target_speed - enemy.velocity)
					#
			#enemy.velocity += grapple_dif * delta
		
		if player.global_position.distance_to(alma_end.global_position) < 2:
			remote_transform.queue_free()
			remote_transform = RemoteTransform3D.new()
			is_enemy_grapple = false
			rope_go_back = true
			
	if is_grappling:
		print("rope_balls")
		alma_end.top_level = true
		rope_go = false
		rope_go_back = false
		rope_gen.SetPlayerPosition(alma.global_position)
		rope_gen.SetGrappleHookPosition(alma_end.global_position)
		if grapple_type == 0:
			var grapple_dir = (alma_end.global_position - player.global_position).normalized()
			var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX * 5
				
			var grapple_dif = (grapple_target_speed - player.velocity)
				
			player.velocity += grapple_dif * delta
		if player.global_position.distance_to(alma_end.global_position) < 2:
			is_grappling = false
			rope_go_back = true
			
	if rope_go_back:
		print("rope_goblack")
		alma_end.top_level = true
		rope_gen.visible = true
		rope_gen.SetPlayerPosition(alma.global_position)
		rope_gen.SetGrappleHookPosition(alma_end.global_position)
		alma_end.global_position = alma_end.global_position.move_toward(alma.global_position, delta*alma_speed)
		alma_end.rotation = alma_end.rotation.move_toward(alma.rotation, delta*alma_speed)
		print("WOWWWWW")
		print(alma_end.global_position)
		print(alma.global_position)
		print(alma_end.global_position.distance_to(alma.global_position))
		if alma_end.global_position.distance_to(alma.global_position) <= 0.000001:
			alma_end.global_position = alma.global_position
			print("WHYYYYY")
			print(alma_end,global_position)
			print(alma.global_position)
			alma_end.top_level = false
			rope_gen.visible = false
			charge = 0.0
			is_grappling = false
			rope_go_back = false
			hook.rotation = Vector3(0, 0, 0)
		
	 #If not pulling
	if is_grappling and grapple_type == 1:
		
		var target_dir = player.global_position.direction_to(alma_end.global_position)
		var target_dist = player.global_position.distance_to(alma_end.global_position)
		
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

		
	#rope_gen.SetGrappleHookPosition(alma_end.global_position)
	#if is_grappling and Input.is_action_pressed("secondary_fire"):
		#rope_gen.SetPlayerPosition(alma.global_position)
		#
		#var grapple_dir = (grapple_hook_position - player.position).normalized()
		#var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX
			#
		#var grapple_dif = (grapple_target_speed - player.velocity)
			#
		#player.velocity += grapple_dif * delta
	#else:
		#rope_gen.visible = false
		
#func grapple(_delta):
	
	#var grapple_dir = (grapple_hook_pos - player.position).normalized()
	#var grapple_target_speed = grapple_dir * grapple_force_max
	#
	#var grapple_dif = (grapple_target_speed - player.velocity)
	#
	#player.velocity += grapple_dif * _delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("was")


func _on_area_3d_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	print("was")
