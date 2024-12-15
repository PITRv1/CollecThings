extends Control

@onready var pause_menu : Node3D = get_tree().get_first_node_in_group("Pause_menu")
const main_menu = preload("res://Maps/Main menu/Main_menu.tscn")

func _ready() -> void:
	get_tree().paused = false


func Show_or_hide_settings():
	if $SettingsMargin.visible:
		$SettingsMargin.hide()
	else:
		$SettingsMargin.show()


func _on_resume_pressed() -> void:
	pause_menu.resume()


func _on_options_pressed() -> void:
	Show_or_hide_settings()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Maps/Main menu/Main_menu.tscn"))


func _on_reload_pressed() -> void:
	get_tree().reload_current_scene()


func _on_done_pressed() -> void:
	Show_or_hide_settings()
