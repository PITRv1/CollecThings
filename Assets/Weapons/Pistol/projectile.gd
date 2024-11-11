extends RayCast3D

var player
var b_decal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	b_decal = preload("res://Assets/Models/BulletDecal.tscn")
	print("apple")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * 50.0 * delta
	target_position = Vector3.FORWARD * 50.0 * delta
	
	force_raycast_update()
	
	if is_colliding() and get_collider() != player:
		var b = b_decal.instantiate()
		get_collider().add_child(b)
		b.global_position =  get_collision_point()
		b.look_at(get_collision_point() + get_collision_normal(), Vector3.UP)
		queue_free()
