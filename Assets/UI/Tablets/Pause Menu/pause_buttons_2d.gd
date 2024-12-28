extends Control

@onready var pause_menu : Node3D = get_tree().get_first_node_in_group("Pause_menu")
@onready var player_safe_mode = get_tree().get_first_node_in_group("player").safe_mode

func _ready() -> void:
	get_tree().paused = false
	


func _show_or_hide_settings():
	if $SettingsMargin.visible:
		$SettingsMargin.hide()
	else:
		$SettingsMargin.show()


func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	_show_or_hide_settings()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(Global.main_menu)


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_done_pressed() -> void:
	_show_or_hide_settings()
	$GameSaverLoader._save_settings()


func _on_debug_save_map_data_pressed() -> void:
	$GameSaverLoader._save_current_map_data()


func _on_debug_load_map_data_pressed() -> void:
	$GameSaverLoader._load_saved_map_data()
