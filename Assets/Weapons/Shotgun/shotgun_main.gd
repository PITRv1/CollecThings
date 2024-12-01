extends  BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/BulletDecal.tscn")
@onready var kurbli: MeshInstance3D = $Shotgun/Kurbli
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var rope_gen: MeshInstance3D = $RopeGen

var charge : float
var _camera : Camera3D
var _mousepos : Vector2
var _space_state : PhysicsDirectSpaceState3D
var _from : Vector3
var _to : Vector3
var _query : PhysicsRayQueryParameters3D
@export var GRAPPLE_RAY_MAX : float = 30.0
@export var GRAPPLE_FORCE_MAX : float = 20.0
var ray
var grapple_raycast_hit
var grapple_hook_position
var is_grappling : bool

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if Input.is_action_pressed("secondary_fire"):
		charge += delta
		kurbli.rotation.x += -5 * delta
	else:
		kurbli.rotation.x = lerp(kurbli.rotation.x, 0.0, delta*10)
		
func _physics_process(delta: float) -> void:
	ray = run_ray_test()
	if ray.size() == 0:
		ray["collider"] = null

	grapple_raycast_hit = ray["collider"]
	if Input.is_action_just_pressed("secondary_fire"):
		if grapple_raycast_hit:
			grapple_hook_position = ray["position"]
			is_grappling = true
			rope_gen.SetPlayerPosition(player.global_position)
			rope_gen.SetGrappleHookPosition(grapple_hook_position)
			rope_gen.StartDrawing()
			rope_gen.visible = true
		else:
			rope_gen.visible = false
			is_grappling = false
		
	if is_grappling and Input.is_action_pressed("secondary_fire"):
		print("alma")
		rope_gen.SetPlayerPosition(global_position)
		
		var grapple_dir = (grapple_hook_position - player.position).normalized()
		var grapple_target_speed = grapple_dir * GRAPPLE_FORCE_MAX
			
		var grapple_dif = (grapple_target_speed - player.velocity)
			
		player.velocity += grapple_dif * delta
		
func run_ray_test() -> Dictionary:
	_space_state = get_world_3d().direct_space_state
	_camera = get_viewport().get_camera_3d()
	_mousepos = get_viewport().get_mouse_position()
	
	# Project ray
	_from = _camera.project_ray_origin(_mousepos)
	_to = _from + _camera.project_ray_normal(_mousepos) * GRAPPLE_RAY_MAX
	
	_query = PhysicsRayQueryParameters3D.create(_from, _to)
	
	return _space_state.intersect_ray(_query)
		
#func grapple(_delta):
	
	#var grapple_dir = (grapple_hook_pos - player.position).normalized()
	#var grapple_target_speed = grapple_dir * grapple_force_max
	#
	#var grapple_dif = (grapple_target_speed - player.velocity)
	#
	#player.velocity += grapple_dif * _delta
