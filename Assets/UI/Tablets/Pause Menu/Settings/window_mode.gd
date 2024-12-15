extends HBoxContainer

@onready var viewport : Viewport = get_tree().root

func _on_windowed_pressed() -> void:
	viewport.mode = Window.MODE_WINDOWED


func _on_fullscreen_pressed() -> void:
	viewport.mode = Window.MODE_FULLSCREEN
