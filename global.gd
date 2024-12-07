extends Node

const LOADING_SCREEN : PackedScene = preload("res://Utilities/Loading Screen/LoadingScreen.tscn")
const MAIN_MENU : PackedScene = preload("res://Maps/Main menu/Main_menu.tscn")

var player : Player
var next_scene: String

func change_scene_to(scene_path: String) -> void:
	if scene_path:
		next_scene = scene_path
		get_tree().change_scene_to_packed(LOADING_SCREEN)
		
