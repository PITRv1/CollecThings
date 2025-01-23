extends Control

signal play_shutdown

func _on_button_pressed() -> void:
	play_shutdown.emit()
