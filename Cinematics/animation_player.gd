extends AnimationPlayer

@onready var animation_player = $"."
@onready var camera_high = $"../Camera_High"
@onready var camera_low = $"../Camera_Low"
@onready var timer: Timer = $"../Timer"

var current_camera = camera_high


func _ready():
	current_camera = camera_high
	AudioPlayer.stop()
	

func switch_camera():
		if current_camera == camera_high:
			current_camera.current = false
			current_camera = camera_low
			current_camera.current = true
		else:
			current_camera.current = false
			current_camera = camera_high
			current_camera.current = true
	

func _process(delta: float) -> void:
	if not animation_player.is_playing() or Input.is_action_just_pressed("ui_accept"):
		if timer.is_stopped():
			timer.start(2.0)
	

func _on_timer_timeout() -> void:
	Global.change_scene_to("res://Maps/Test Maps/Env_Asset_Test_map/env_asset_test_map.tscn")
