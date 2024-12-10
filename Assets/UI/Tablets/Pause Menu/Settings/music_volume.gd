extends HBoxContainer


func _ready() -> void:
	$SliderBox/HSlider.value = AudioPlayer.default_volume 
	


func _on_h_slider_value_changed(value: float) -> void:
	AudioPlayer.volume_db = value
	AudioPlayer.default_volume = value
