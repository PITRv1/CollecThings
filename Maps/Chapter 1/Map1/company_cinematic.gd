extends Area3D

@onready var anim_player : AnimationPlayer = $"../AnimationPlayer2"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var camera_3d : Camera3D = $"../Camera3D"
@onready var flame_4 : GPUParticles3D = $"../../../tower/Flame4"
@onready var player : Player = get_tree().get_first_node_in_group("player")

var current_cam : Camera3D


func cam_switch() -> void:
		current_cam = camera_3d
		current_cam.current = true
		player.velocity = Vector3.ZERO
		player.ui.visible = false
		player.crosshair.visible = false
		
func cam_switch2() -> void:
		current_cam.current = false
		player.velocity = Vector3.ZERO
		player.ui.visible = true
		player.crosshair.visible = true
		


func _on_body_entered(body) -> void:
	if player.inventory.has("items"):
		var items : Array = player.inventory.get("items")
		
		if "explosives" in items and "megatalk" in items:
			
			$"../Label3D".visible = false
			anim_player.play("explosion")
			await anim_player.animation_finished
			
			anim_player.play("zoom in and out")
			await anim_player.animation_finished
			
			$"../../Camera3D".current = true
			animation_player.play("leaving")
			await animation_player.animation_finished
			
			Global.change_scene_to("res://Cinematics/2D intros/Ending/ending.tscn")
			
		else:
			Global.stat_tablet.purge_message("We need a radio and a explosive")
	else:
		Global.stat_tablet.purge_message("I've noticed a craftbench at hub. We should check it out.")
		
