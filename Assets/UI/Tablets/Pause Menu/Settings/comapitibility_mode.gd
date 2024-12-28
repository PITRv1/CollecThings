extends HBoxContainer


func _on_auto_pressed() -> void:
	$"../../../../GameSaverLoader".set_safe_mode(0)
	

func _on_disable_pressed() -> void:
	$"../../../../GameSaverLoader".set_safe_mode(1)
	

func _on_performance_pressed() -> void:
	$"../../../../GameSaverLoader".set_safe_mode(2)
	

func _on_safe_pressed() -> void:
	$"../../../../GameSaverLoader".set_safe_mode(3)
	
