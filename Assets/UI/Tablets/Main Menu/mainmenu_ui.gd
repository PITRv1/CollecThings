extends Control

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/Test Maps/Env_Asset_Test_map/env_asset_test_map.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
