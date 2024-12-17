extends HBoxContainer

@onready var viewport : Viewport = get_tree().root
@onready var display_size = DisplayServer.window_get_size()

func _on_default_pressed() -> void:
	change_resoltuion(Vector2i(display_size[0]+2, display_size[1]+2))


func _on_k_pressed() -> void:
	change_resoltuion(Vector2i(2560, 1440))


func _on_full_hd_pressed() -> void:
	change_resoltuion(Vector2i(1920, 1080))


func _on_hd_pressed() -> void:
	change_resoltuion(Vector2i(1280, 720))

func change_resoltuion(resolution: Vector2i):
	viewport.content_scale_size = resolution
