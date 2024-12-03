extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const MAIN_MENU = preload("res://Maps/Main menu/Main_menu.tscn")

func _process(delta: float) -> void:
	if not animation_player.is_playing():
		get_tree().change_scene_to_packed(MAIN_MENU)
