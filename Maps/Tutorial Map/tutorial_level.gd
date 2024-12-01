extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_enemy_trigger_area_entered(_area: Area3D) -> void:
	animation_player.play("Fight trigger")
