extends HBoxContainer


func _on_button_pressed() -> void:
	var viewport : Viewport = get_tree().root
	viewport.content_scale_size = Vector2i(1920, 1080)
	viewport.mode = Window.MODE_FULLSCREEN
	
