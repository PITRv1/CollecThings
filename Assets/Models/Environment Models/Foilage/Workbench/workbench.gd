extends Node3D

@onready var audio_player : AudioStreamPlayer3D = $AudioStreamPlayer3D

var computer_running_sfx : AudioStreamMP3 = preload("res://Assets/Sounds/computer_running.mp3")

func _on_start_workbench_anim_play_workbench_start() -> void:
	audio_player.play()
	
	await audio_player.finished
	$black_screen.visible = false
	computer_running_sfx.loop = true
	audio_player.stream = computer_running_sfx
	audio_player.play()
	
	get_node("workbench_screen/viewport/WorkbenchUi2d/AnimationPlayer").play("load")
