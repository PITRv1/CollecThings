extends Node

func _on_body_entered(body: Player) -> void:
	get_tree().reload_current_scene()
