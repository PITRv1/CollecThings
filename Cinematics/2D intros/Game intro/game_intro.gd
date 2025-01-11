extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const INTRO = preload("res://Cinematics/3D Cinematics/Intro/intro.tscn")
const INTRO_MUSIC = preload("res://Assets/Musics/intro1.mp3")

func _ready() -> void:
	AudioPlayer._play_music(INTRO_MUSIC, -4)

func _process(_delta: float) -> void:
	if not animation_player.is_playing():
		AudioPlayer.stop()
		get_tree().change_scene_to_packed(INTRO)
	
	if Input.is_action_just_pressed("ui_accept"):
		AudioPlayer.stop()
		get_tree().change_scene_to_packed(Global.main_menu)
	
