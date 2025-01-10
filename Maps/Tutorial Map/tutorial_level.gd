extends Node3D

@onready var stat_tablet = Global.stat_tablet
@onready var basic_enemy : PackedScene = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")
@onready var break_away_enemies_rock: Node3D = $NavigationRegion3D/Environment/EnemyFight_Room/BreakAwayEnemies_Rock
@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var little_rock : PackedScene = preload("res://Assets/Models/Environment Models/Foilage/Rocks/Mineral_rocks/mineral_rock_no_emis.tscn")

@onready var rock_pos : Vector3 = $NavigationRegion3D/Environment/BrokenDoor_Room/BreakableRock.global_position

var spawned_rocks : bool = false

@onready var take_off_cam: Camera3D = $CamPivot/TakeOffCam
@onready var tako_off_animation_p: AnimationPlayer = %TakoOffAnimationP
@onready var space_ship: Node3D = $Space_ship/Space_ship

#List of to be deleted rocks
@onready var fallen_rock_piece: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece
@onready var fallen_rock_piece_2: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece2
@onready var fallen_rock_piece_3: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece3
@onready var fallen_rock_piece_4: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece4
@onready var fallen_rock_piece_5: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece5
@onready var fallen_rock_piece_6: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece6
@onready var fallen_rock_piece_7: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece7
@onready var fallen_rock_piece_8: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece8
@onready var fallen_rock_piece_9: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece9
@onready var fallen_rock_piece_10: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece10
@onready var fallen_rock_piece_11: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece11
@onready var fallen_rock_piece_12: RigidBody3D = $NavigationRegion3D/Environment/EnemyFight_Room/FallenRockPiece12


var rocklist := []


func _ready() -> void:
	rocklist = [fallen_rock_piece,fallen_rock_piece_2,fallen_rock_piece_3,fallen_rock_piece_4,fallen_rock_piece_5,fallen_rock_piece_6,fallen_rock_piece_7,fallen_rock_piece_8,fallen_rock_piece_9,fallen_rock_piece_10,fallen_rock_piece_11,fallen_rock_piece_12]
	freeze_falling_rocks(true)
	
	stat_tablet.purge_message("Move with WASD")
	
	tako_off_animation_p.play("RESET")
	player.health_component.health = 75
	
	for enemy in $Enemies.get_children():
		enemy.hitbox_component.health_component.died.connect(_check_if_all_enemy_died)
	


func _check_if_all_enemy_died() -> void:
	if $Enemies.get_children().size() == 1: #why 1????? -Dani
		$NavigationRegion3D/Environment/EnemyFight_Room/AnimationPlayer.play("rock_fall")
	

var door_broken := false
func _on_enemy_trigger_body_entered(body: Player) -> void:
	if not door_broken:
		freeze_falling_rocks(false)
		break_away_enemies_rock.queue_free()
		delete_falling_rocks()
		door_broken = true
		
	


func freeze_falling_rocks(freeze_value:bool):
	for rock in rocklist:
		rock.freeze = freeze_value


func delete_falling_rocks():
	await get_tree().create_timer(6).timeout
	for rock in rocklist:
		rock.queue_free()


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
	stat_tablet.purge_message("You completed the tutorial. Good job You may leave with your ship now.")


func _on_temp_load_next_level_body_entered(body: Node3D) -> void:
	Global.change_scene_to("res://Cinematics/3D Cinematics/Crash/crash_animation.tscn")

func _on_end_scene_trigger_body_entered(body: Node3D) -> void:
	var from = player.camera
	var to = take_off_cam
	
	player.velocity = Vector3.ZERO
	player.paused = true
	player.ui.visible = false
	player.weapon_controller.visible = false
	player.crosshair.visible = false
	
	var tween:Tween
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	

	#tween.tween_property(from, "rotation", from.look_at(space_ship.global_position))
	tween.tween_property(from, "fov", to.fov, 2)
	tween.tween_property(from, "global_transform", to.global_transform, 5)
	tween.tween_property(from, "fov", to.fov, 2)
	await tween.finished
	
	from.current = false
	to.current = true
	
	if tako_off_animation_p.has_animation("Take_off"):
		tako_off_animation_p.play("Take_off")
		
	await tako_off_animation_p.animation_finished
	
	player.paused = false
	player.weapon_controller.visible = true
	player.ui.visible = true
	player.crosshair.visible = true
	Global.change_scene_to("res://Cinematics/3D Cinematics/Crash/crash_animation.tscn")


# ROCK dies and spawns little rock (Jr Rocks)
func _on_health_component_died() -> void:
	if !spawned_rocks:
		for i in range(0, 6):
			var rock := little_rock.instantiate()
			rock.global_position = rock_pos + Vector3(randf_range(0, i*0.5), randf_range(0, i*0.5), randf_range(0, i*0.5))
			rock.scale = Vector3(0.5, 0.5, 0.5)
			rock.rotation = Vector3(randf_range(0, i*0.5), randf_range(0, i*0.5), randf_range(0, i*0.5))
			get_tree().current_scene.add_child(rock)
			
			spawned_rocks = true
	


func _on_crystall_fall_body_entered(body: Player) -> void:
	if $NavigationRegion3D/Environment/LargeCave_Room/Crystal8:
		$NavigationRegion3D/Environment/LargeCave_Room/Crystal8.freeze = false
		get_tree().create_timer(5).timeout.connect(func(): if $NavigationRegion3D/Environment/LargeCave_Room/Crystal8: $NavigationRegion3D/Environment/LargeCave_Room/Crystal8.queue_free())


func _on_easter_egg_body_entered(body: Node3D) -> void:
	Global.change_scene_to("res://Maps/Test Maps/Easter egg/egg.tscn")
