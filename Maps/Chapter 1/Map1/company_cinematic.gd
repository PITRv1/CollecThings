extends Area3D

@onready var anim_player = $"../AnimationPlayer2"
@onready var camera_3d = $"../Camera3D"
@onready var flame_4 = $"../../../tower/Flame4"

var player_cam = Camera3D
var current_cam = Camera3D


func cam_switch():
		current_cam = camera_3d
		current_cam.current = true
		
func cam_switch2():
		current_cam.current = false
		


func _on_body_entered(body):
	print("alma")
	anim_player.play("zoom in and out")
