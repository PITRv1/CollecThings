extends HBoxContainer



func _ready() -> void:
	$SliderBox/HSlider.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	
	
