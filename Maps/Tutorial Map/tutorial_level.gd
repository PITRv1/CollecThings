extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stat_tablet = Global.stat_tablet

func _ready() -> void:
	stat_tablet.purge_message("Move with WASD")

func _on_enemy_trigger_area_entered(_area: Area3D) -> void:
	animation_player.play("Fight trigger")


func _on_grappler_body_entered(body: Player) -> void:
	stat_tablet.purge_message(
	"Shoot with Left click
	Charge grappler with Right click")


func _on_jump_body_entered(body: Player) -> void:
	stat_tablet.purge_message(
	"Jump with Space
	Dash with Shift")


func _on_area_3d_body_entered(body: Player) -> void:
	stat_tablet.purge_message("Shoot the rock to get through!")


func _on_leave_body_entered(body: Player) -> void:
	stat_tablet.purge_message("You completed the tutorial. Good job! Go to your ship and leave.")


func _on_temp_load_next_level_body_entered(body: Node3D) -> void:
	Global.change_scene_to("res://Cinematics/3D Cinematics/Crash/crash_animation.tscn")
