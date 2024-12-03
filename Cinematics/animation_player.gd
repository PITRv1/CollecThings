extends AnimationPlayer

@onready var animation_player = $"."
@onready var camera_high = $"../Camera_High"
@onready var camera_low = $"../Camera_Low"
@onready var space_ship = $"../Path3D/PathFollow3D/Space_ship"


var current_camera = camera_high
var anim_time = null


func _ready():
	current_camera = camera_high
	
	
func switch_camera():
	
		if current_camera == camera_high:
			current_camera.current = false
			current_camera = camera_low
			current_camera.current = true
		else:
			current_camera.current = false
			current_camera = camera_high
			current_camera.current = true
	

	
	
