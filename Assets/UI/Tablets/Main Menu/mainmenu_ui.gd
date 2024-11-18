extends Control

@export var Scene_to_load : PackedScene

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(Scene_to_load)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
