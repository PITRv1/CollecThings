extends HBoxContainer

var pixelization_shader = null

func _ready() -> void:
	pixelization_shader = Global.get_environment_shader_by_property("down_scaling")
	
	if pixelization_shader == null:
		$SliderBox/HSlider.editable = false
		
	

func _on_h_slider_value_changed(value: float) -> void:
	pixelization_shader.set("down_scaling", value)
	


func _on_h_slider_mouse_entered() -> void:
	$SliderBox/HSlider.editable = Global.safe_mode_status
	
