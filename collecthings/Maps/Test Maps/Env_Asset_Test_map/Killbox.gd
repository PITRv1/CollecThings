extends Node


func _on_body_entered(body: Node3D) -> void:
	var current_scene = get_tree().root
	get_tree().change_scene_to_packed(current_scene)
