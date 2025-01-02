extends Node3D

const MUSIC = preload("res://Assets/Musics/Lost in Fields of Nothing.mp3")

var speed : float = 0.005

func _ready() -> void:
	AudioPlayer._play_music(MUSIC)

func _process(delta: float) -> void:
	$".".rotate_y(speed*delta)
	$".".rotate_x(speed*delta)
