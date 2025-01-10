extends Node3D


func _ready() -> void:
	AudioPlayer.stop_music()
	get_tree().create_timer(2).timeout.connect(func(): $AnimationPlayer.play("look"))
	$Camera3D/AudioStreamPlayer.play()
	get_tree().create_timer(14.2).timeout.connect(func(): $AnimationPlayer.play("anim"))
	get_tree().create_timer(42.5).timeout.connect(func(): $AnimationPlayer2.play("spin"))
	
	
	$Camera3D/AudioStreamPlayer.finished.connect(func(): get_tree().quit())
	
	
