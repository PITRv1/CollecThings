extends BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/Bullet/BulletDecal.tscn")
@onready var monger : PackedScene = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")

var charge : float
var knock_force : float
var damage : float


func primary_fire():
	var _space_state : PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var _mousepos : Vector2 = get_viewport().get_mouse_position()
	var _camera : Camera3D = get_viewport().get_camera_3d()
	var _from : Vector3= _camera.project_ray_origin(_mousepos)
	var _to : Vector3 = _from + _camera.project_ray_normal(_mousepos) * 30
	var _query : PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(_from, _to)
	var _result : Dictionary = _space_state.intersect_ray(_query)
	
	if _result:
		var mong : CharacterBody3D = monger.instantiate()
		get_tree().root.add_child(mong)
		mong.global_position = _result["position"]
