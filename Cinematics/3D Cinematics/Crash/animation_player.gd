extends AnimationPlayer

@onready var animation_player = $"."
@onready var camera_high = $"../Camera_High"
@onready var camera_low = $"../Camera_Low"
@onready var timer: Timer = $"../Timer"

const RIADO = preload("res://Assets/Musics/riado.mp3")

# Prev colors: c1d5ff and 312073c8

var current_camera = camera_high


func _ready():
	current_camera = camera_high
	get_tree().create_timer(5).timeout.connect(func(): AudioPlayer._play_music(RIADO, 10))
	
	

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
	if not animation_player.is_playing():
		
		get_tree().create_timer(3.0).timeout.connect(func(): change_map())
			
	if Input.is_action_just_pressed("ui_accept"):
		change_map()


func change_map() -> void:
	Global.change_scene_to("res://Maps/Hub/hub_map.tscn")
