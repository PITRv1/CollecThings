extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const CRASH_ANIMATION = preload("res://Cinematics/crash_animation.tscn")

func _on_enemy_trigger_area_entered(_area: Area3D) -> void:
	animation_player.play("Fight trigger")


func _on_temp_load_next_level_area_entered(area: Area3D) -> void:
	get_tree().change_scene_to_packed(CRASH_ANIMATION)
