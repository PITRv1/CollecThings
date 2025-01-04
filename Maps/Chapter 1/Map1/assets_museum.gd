extends Area3D

@export var next_scene := preload("res://Assets/Assets_museum/assets_museum.tscn") 

func _on_body_entered(body: Node3D) -> void:
	Global.change_scene_to(next_scene.resource_path)
	
	


	
