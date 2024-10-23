extends Node

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().reload_current_scene()
