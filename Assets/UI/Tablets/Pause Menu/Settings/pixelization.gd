extends HBoxContainer

var pixelization_shader = null

func _ready() -> void:
	get_tree().create_timer(1, true, true, 0).timeout.connect(set_pixelization_amount)

func set_pixelization_amount():
	pixelization_shader = Global.get_environment_shader_by_property("down_scaling")
	
	if pixelization_shader == null:
		$SliderBox/HSlider.editable = false
	
	if pixelization_shader:
		$SliderBox/HSlider.value = pixelization_shader.get("down_scaling")
	


func _on_h_slider_value_changed(value: float) -> void:
	$"../../../../GameSaverLoader".set_pixelization_amount(value)
	


func _on_h_slider_mouse_entered() -> void:
	$SliderBox/HSlider.editable = Global.safe_mode_status
	
