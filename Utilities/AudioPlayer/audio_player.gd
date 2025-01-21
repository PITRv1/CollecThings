extends AudioStreamPlayer

@export var default_volume : float = -8.0
const MUSIC_LIBRARY : Dictionary = {
	"Untitled" : preload("res://Assets/Musics/Untitled.mp3"),
	"Lost_in_fields_of_nothing" : preload("res://Assets/Musics/Lost in Fields of Nothing.mp3"),
	"Crash_alarm" :  preload("res://Assets/Musics/Alarm.mp3")
}

var num_of_audios : int = 0
var max_audios : int = 6

func play_music(music: AudioStreamMP3, volume: float = default_volume) -> void:
	if stream == music: 
		return
	
	stream = music
	volume_db = volume
	play()


func stop_music():
	stop()
	stream = null


func create_new_audio_player(sound, volume: float = default_volume) -> void:
	if num_of_audios == max_audios or num_of_audios > max_audios: return
	
	var audio := AudioStreamPlayer.new()
	
	audio.volume_db = volume
	audio.stream = sound
	
	get_tree().current_scene.add_child(audio)
	
	audio.play()
	
	num_of_audios += 1
	
	get_tree().create_timer(sound.get_length()).timeout.connect(func(): _remove_audio(audio))
	

func _remove_audio(audio: AudioStreamPlayer) -> void:
	audio.queue_free()
	num_of_audios -= 1
	
