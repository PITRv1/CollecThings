extends Node3D

@onready var stat_tablet = Global.stat_tablet
@onready var basic_enemy : PackedScene = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")
@onready var enemy_spawn : Marker3D = $NavigationRegion3D/Environment/EnemySpawn
@onready var collision_shape_3d: CollisionShape3D = $NavigationRegion3D/Environment/StaticBody3D/CollisionShape3D

func _ready() -> void:
	stat_tablet.purge_message("Move with WASD")
	#spawn_basic_enemy(5 , Vector3(1, 0, 0)) #first are is for amount second is offset from global pos
	#if we spawn on ready might as well use the editor.

func _on_enemy_trigger_body_entered(body: Player) -> void:
	collision_shape_3d.disabled = true


func spawn_basic_enemy(amount:int, offset: Vector3) -> void:
	for i in range(0, amount):
		var enemy : CharacterBody3D = basic_enemy.instantiate()
		enemy.global_position = enemy_spawn.global_position + offset
		get_tree().current_scene.add_child(enemy)


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
