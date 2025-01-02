extends Node3D

@onready var stat_tablet = Global.stat_tablet
@onready var basic_enemy : PackedScene = preload("res://Entities/Enemy/Basic enemy test/monger.tscn")
@onready var collision_shape_3d: CollisionShape3D = $NavigationRegion3D/Environment/StaticBody3D/CollisionShape3D
@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var little_rock : PackedScene = preload("res://Assets/Models/Environment Models/Foilage/Rocks/Mineral_rocks/mineral_rock_no_emis.tscn")

@onready var rock_pos : Vector3 = $NavigationRegion3D/Environment/rock1.global_position

var spawned_rocks : bool = false

@onready var take_off_cam: Camera3D = $CamPivot/TakeOffCam
@onready var tako_off_animation_p: AnimationPlayer = %TakoOffAnimationP
@onready var space_ship: Node3D = $Space_ship/Space_ship

func _ready() -> void:
	stat_tablet.purge_message("Move with WASD")
	
	
	tako_off_animation_p.play("RESET")
	player.health_component.health = 75
	
	#spawn_basic_enemy(5 , Vector3(1, 0, 0)) #first are is for amount second is offset from global pos
	#if we spawn on ready might as well use the editor.


func _on_enemy_trigger_body_entered(body: Player) -> void:
	collision_shape_3d.disabled = true


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
	if $Crystals/Crystal8:
		$Crystals/Crystal8.freeze = false
		get_tree().create_timer(5).timeout.connect(func(): if $Crystals/Crystal8: $Crystals/Crystal8.queue_free())

