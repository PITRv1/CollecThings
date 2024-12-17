extends HBoxContainer

@onready var player_safe_mode = get_tree().get_first_node_in_group("player").safe_mode


func _on_auto_pressed() -> void:
	player_safe_mode.mode = 0
	player_safe_mode.reload()


func _on_disable_pressed() -> void:
	print("disabled")
	player_safe_mode.mode = 1
	player_safe_mode.reload()
	
	print(Global.safe_mode_status)


func _on_performance_pressed() -> void:
	player_safe_mode.mode = 2
	player_safe_mode.reload()
	


func _on_safe_pressed() -> void:
	player_safe_mode.mode = 3
	player_safe_mode.reload()
	
