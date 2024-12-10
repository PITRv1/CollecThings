class_name DeadPlayerState

extends PlayerMovementState

@onready var timer: Timer = $Timer

signal died

var t

func enter(_previous_state):
	print("died")
	Engine.time_scale = 0.0


func _on_health_component_died() -> void:
	print("died")
	print(Engine.time_scale)
	if not t:
		t = get_tree().create_tween()
		t.set_speed_scale(1/Engine.time_scale)
		t.tween_property(Engine, "time_scale", 0.1, 1)
		t.tween_callback(died_end)
	
func died_end():
	print("WAKE UP")
	t.stop()
	t.kill()
	t = null
	Engine.time_scale = 1
	get_tree().reload_current_scene()
	
	
