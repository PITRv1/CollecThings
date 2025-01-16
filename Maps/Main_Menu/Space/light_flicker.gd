extends SpotLight3D

@export var timer : Timer

var rng = RandomNumberGenerator.new()
var target_light_energy: float = 4

func _process(delta: float) -> void:
	light_energy = lerp(light_energy, target_light_energy, .5 * delta)
	
func _on_timer_timeout() -> void:
	target_light_energy = rng.randf_range(2, 4)
	
	timer.wait_time = rng.randf_range(0.0, 2)
