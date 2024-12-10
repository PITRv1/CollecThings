extends Control

@onready var pause_menu : Node3D = get_tree().get_first_node_in_group("Pause_menu")

func _ready() -> void:
	get_tree().paused = false


func Show_or_hide_settings():
	if $UIMargin.visible:
		$UIMargin.hide()
		$SettingsMargin.show()
	else:
		$UIMargin.show()
		$SettingsMargin.hide()


func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	Show_or_hide_settings()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(Global.main_menu)


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_done_pressed() -> void:
	Show_or_hide_settings()
