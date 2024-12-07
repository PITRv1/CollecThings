extends Control

func _ready() -> void:
	get_tree().paused = false

func _on_play_button_pressed() -> void:
	Global.change_scene_to("res://Maps/Test Maps/Env_Asset_Test_map/env_asset_test_map.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_tutorial_button_pressed() -> void:
	Global.change_scene_to("res://Maps/Tutorial Map/tutorial_level.tscn")
