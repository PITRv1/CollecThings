extends AudioStreamPlayer2D

const MUSIC = preload("res://Assets/Musics/Lost in Fields of Nothing.mp3")

func _play_music(music: AudioStreamMP3, volume: float = -8.0):
	if stream == music: 
		return
		
	stream = music
	volume_db = volume
	play()

func play_music():
	_play_music(MUSIC, 0)
	

func stop_music():
	stop()
