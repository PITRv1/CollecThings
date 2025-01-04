extends Area3D

@export var next_scene : PackedScene

func _on_body_entered(body: Node3D) -> void:
	Global.change_scene_to(next_scene.resource_path)
	
