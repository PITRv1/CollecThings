extends AudioStreamPlayer2D

const MUSIC : AudioStreamMP3 = preload("res://Assets/Musics/Lost in Fields of Nothing.mp3")
@export var default_volume : float = -8.0

func _play_music(music: AudioStreamMP3, volume: float = default_volume):
	if stream == music: 
		return
	
	stream = music
	volume_db = volume
	play()


func play_music():
	_play_music(MUSIC)
	

func stop_music():
	stop()
