extends Node3D

@export_category("Object spawner")
@export var parent_node : Node
@export var spawned_obj_per_parent : int = 1
@export var obj_to_spawn : Array[PackedScene]
@export_range(0, 10, 0.001) var pos_randomness : float = 3.0
@export_range(0, 10, 0.1) var scale_randomness : float = 1.0


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
				
	
	


@onready var basic_enemy1 : PackedScene = preload("res://Entities/Enemy/abel_teszt/abel.tscn")
@onready var basic_enemy2 : PackedScene = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")
@onready var forest : PackedScene = preload("res://Assets/Models/Environment Models/Foilage/Forests/Lightgreen Forest/lightgreen_forest.tscn")
#FIGHT
func _on_area_3d_body_entered(_body: Player) -> void:
	$"Fight Area/Area3D".queue_free()
	
	for marker : Marker3D in [$"Fight Area/Leave", $"Fight Area/Enter"]:
		var trees : Node3D = forest.instantiate()
		
		trees.global_position = marker.global_position
		trees.scale = Vector3(0.5,0.5,0.5)
		
		get_tree().current_scene.add_child(trees)
	
	for i in range(0,6):
		get_tree().create_timer(1*i).timeout.connect(spawn_enemy)
		
	


func spawn_enemy():
	var enemy : CharacterBody3D = basic_enemy1.instantiate()
	get_tree().current_scene.add_child(enemy)
	enemy.global_position = $"Fight Area/Enemy spawner".global_position
	
	
