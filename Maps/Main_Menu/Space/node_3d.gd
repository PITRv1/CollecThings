extends Node3D

var speed : float = 0.005

func _ready() -> void:
	AudioPlayer.play_music(AudioPlayer.MUSIC_LIBRARY["Lost_in_fields_of_nothing"])

func _process(delta: float) -> void:
	$".".rotate_y(speed*delta)
	$".".rotate_x(speed*delta)
