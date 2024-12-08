extends BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/Bullet/BulletDecal.tscn")

var charge : float
var knock_force : float
var damage : float
var monger

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	monger = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")

func primary_fire():
	var _space_state = get_world_3d().direct_space_state
	var _mousepos = get_viewport().get_mouse_position()
	var _camera = get_viewport().get_camera_3d()
	var _from = _camera.project_ray_origin(_mousepos)
	var _to = _from + _camera.project_ray_normal(_mousepos) * 30
	
	var _query = PhysicsRayQueryParameters3D.create(_from, _to)
	
	var _result = _space_state.intersect_ray(_query)
	
	if _result:
		var mong = monger.instantiate()
		get_tree().root.add_child(mong)
		mong.global_position = _result["position"]
