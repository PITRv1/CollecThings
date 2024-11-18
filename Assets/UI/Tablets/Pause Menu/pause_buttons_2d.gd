extends Control

@onready var pause_menu : Node3D = get_tree().get_first_node_in_group("Pause_menu")
@export var main_menu_scene : PackedScene

func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_reload_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Maps/Main menu/Main_menu.tscn")
	print(main_menu_scene)
	


func _on_quit_pressed() -> void:
	get_tree().quit()
