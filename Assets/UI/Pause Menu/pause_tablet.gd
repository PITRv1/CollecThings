extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause() -> void:
	animation_player.play("open")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	

func resume() -> void:
	animation_player.play_backwards("open")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
