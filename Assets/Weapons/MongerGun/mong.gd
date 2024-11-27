extends BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/BulletDecal.tscn")

var charge : float
var knock_force : float
var damage : float
var monger

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	monger = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")

func primary_fire():
	var from = camera.project_ray_origin(mousepos)
	var to = from + camera.project_ray_normal(mousepos) * length
	
	var query = PhysicsRayQueryParameters3D.create(from, to)
	
	query.collide_with_areas = true
	query.collide_with_bodies = false
	
	var result = space_state.intersect_ray(query)
	
	if result:
		var mong = monger.instantiate()
		get_tree().add_child(mong)
		mong.global_position = result["position"]
