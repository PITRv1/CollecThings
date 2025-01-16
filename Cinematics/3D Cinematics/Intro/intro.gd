extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const TEAM_INTRO : PackedScene = preload("res://Cinematics/2D intros/Team intro/team_intro.tscn")

func _ready() -> void:
	AudioPlayer.play_music(AudioPlayer.MUSIC_LIBRARY["Lost_in_fields_of_nothing"])

func _process(_delta: float) -> void:
	if not animation_player.is_playing():
		get_tree().change_scene_to_packed(TEAM_INTRO)
	
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_packed(Global.main_menu)
