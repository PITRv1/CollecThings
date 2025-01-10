class_name ObjectSpawner extends Node

@export_category("Object spawner")
@export var parent_node : Node
@export var spawned_obj_per_parent : int = 8
@export var obj_to_spawn : Array[PackedScene]
@export_range(0, 10, 0.001) var pos_randomness : float = 10
@export_range(0, 10, 0.1) var scale_randomness : float = 2.7


func _ready() -> void:
	var parents : Array[Node] = parent_node.get_children()
	
	
	for parent : Node3D in parents:
		var pos : Vector3 = parent.global_position
		
		for i in range(1, spawned_obj_per_parent):
			for obj : PackedScene in obj_to_spawn:
				var randomness := Vector3(randf_range(-pos_randomness, pos_randomness), 1, randf_range(-pos_randomness, pos_randomness))
				var random_scale : float = randf_range(1, scale_randomness) 
				var spawnpos : Vector3 = pos + randomness
				
				var instantiated : Node3D = obj.instantiate()
				get_tree().current_scene.add_child(instantiated)
				instantiated.scale = Vector3(random_scale, random_scale, random_scale)
				instantiated.global_position = spawnpos
				
	
	
