extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const INTRO : PackedScene = preload("res://Cinematics/3D Cinematics/Intro/intro.tscn")


func _process(_delta: float) -> void:
	if not animation_player.is_playing():
		get_tree().change_scene_to_packed(INTRO)
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_packed(Global.main_menu)
	
