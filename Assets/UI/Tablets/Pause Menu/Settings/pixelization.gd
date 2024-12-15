extends HBoxContainer

var current_world_env = null

func get_current_world_environment() -> WorldEnvironment:
	var current_scene = get_tree().current_scene
	if current_scene:
		var world_env = current_scene.get_node_or_null("WorldEnvironment") as WorldEnvironment
		if world_env:
			return world_env
	return null

func _ready() -> void:
	current_world_env = get_current_world_environment()

func _on_h_slider_value_changed(value: float) -> void:
	print(current_world_env.compositor.compositor_effects)
