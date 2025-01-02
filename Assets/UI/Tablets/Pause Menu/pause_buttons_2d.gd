extends Control

@onready var pause_menu : Node3D = get_tree().get_first_node_in_group("Pause_menu")
@onready var player_safe_mode = get_tree().get_first_node_in_group("player").safe_mode

func _ready() -> void:
	get_tree().paused = false
	

func _show_or_hide_settings() -> void:
	if $SettingsMargin.visible:
		$SettingsMargin.hide()
	else:
		$SettingsMargin.show()
	

func _show_or_hide_quit_menu() -> void:
	if $QuitMenu.visible:
		$QuitMenu.hide()
	else:
		$QuitMenu.show()
	

func _show_or_hide_load_menu() -> void:
	if $LoadMenu.visible:
		$LoadMenu.hide()
	else:
		$LoadMenu.show()


func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	_show_or_hide_settings()


func _on_quit_menu_pressed() -> void:
	_show_or_hide_quit_menu()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(Global.main_menu)
	


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_done_pressed() -> void:
	_show_or_hide_settings()
	$GameSaverLoader.save_settings()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_load_pressed() -> void:
	_show_or_hide_load_menu()


func _on_save_pressed() -> void:
	$GameSaverLoader.save_current_map_data()


func _on_back_pressed() -> void:
	_show_or_hide_quit_menu()


func _on_back_load_button_pressed() -> void:
	_show_or_hide_load_menu()


func _on_load_button_pressed() -> void:
	$GameSaverLoader.load_saved_map_data()
