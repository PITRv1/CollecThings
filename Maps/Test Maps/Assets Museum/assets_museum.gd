extends Area3D

@export var next_scene : PackedScene = preload("res://Maps/Test Maps/Assets Museum/assets_museum.tscn") 

func _on_body_entered(_body: Node3D) -> void:
	Global.change_scene_to(next_scene.resource_path)
	
	
