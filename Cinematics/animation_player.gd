extends AnimationPlayer

@onready var animation_player = $"."
@onready var camera_high = $"../Camera_High"
@onready var camera_low = $"../Camera_Low"
@onready var space_ship = $"../Path3D/PathFollow3D/Space_ship"

const ENV_ASSET_TEST_MAP = preload("res://Maps/Test Maps/Env_Asset_Test_map/env_asset_test_map.tscn")

var current_camera = camera_high
var anim_time = null


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
		get_tree().change_scene_to_packed(ENV_ASSET_TEST_MAP)
		
	
	
