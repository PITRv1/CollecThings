extends Control

@onready var pause_menu = get_tree().get_first_node_in_group("Pause_menu")

func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
