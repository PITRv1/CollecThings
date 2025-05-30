extends Control

func _ready() -> void:
	get_tree().paused = false
	
	if !OS.has_feature("debug"):
		$"Margin/VBox/Test Map".queue_free()
		$"Margin/VBox/Asset Museum".queue_free()


func _on_play_button_pressed() -> void:
	Global.change_scene_to("res://Maps/Tutorial Map/tutorial_level.tscn")
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_load_button_pressed() -> void:
	$GameSaverLoader.load_saved_map()
	


func _on_env_button_pressed() -> void:
	Global.change_scene_to("res://Maps/Test Maps/Env_Asset_Test_map/env_asset_test_map.tscn")


func _on_museum_button_pressed() -> void:
	Global.change_scene_to("res://Maps/Test Maps/Assets Museum/assets_museum.tscn")
