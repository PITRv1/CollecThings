extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _process(_delta: float) -> void:
	if not animation_player.is_playing():
		get_tree().change_scene_to_packed(Global.main_menu)
		
