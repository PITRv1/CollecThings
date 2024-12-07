extends Control

@onready var pause_menu : Node3D = get_tree().get_first_node_in_group("Pause_menu")

func _ready() -> void:
	get_tree().paused = false


func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	pass


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(Global.main_menu)


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()
