extends AnimationPlayer

@onready var animation_player = $"."
@onready var camera_high = $"../Camera_High"
@onready var camera_low = $"../Camera_Low"
@onready var timer: Timer = $"../Timer"

var current_camera = camera_high

func _ready() -> void:
	current_camera = camera_high
	
	await get_tree().create_timer(5.6).timeout
	AudioPlayer.play_music(AudioPlayer.MUSIC_LIBRARY["Crash_alarm"])
	
	

func switch_camera() -> void:
		if current_camera == camera_high:
			current_camera.current = false
			current_camera = camera_low
			current_camera.current = true
			
		else:
			current_camera.current = false
			current_camera = camera_high
			current_camera.current = true
	

func _process(delta: float) -> void:
	if not animation_player.is_playing():
		await get_tree().create_timer(3.0).timeout
		change_map()
			
	if Input.is_action_just_pressed("ui_accept"):
		change_map()


func change_map() -> void:
	AudioPlayer.stop()
	Global.change_scene_to("res://Maps/Hub/hub_map.tscn")
