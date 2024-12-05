extends Node3D

const MUSIC = preload("res://Assets/Musics/music.mp3")

func _ready() -> void:
	AudioPlayer._play_music(MUSIC)
