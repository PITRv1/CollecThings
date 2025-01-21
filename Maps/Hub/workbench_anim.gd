extends Area3D

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var marker_3d: Marker3D = $"../../Marker3D"

var look_at_workbench : bool = false

signal play_workbench_start

func _ready() -> void:
	$"..".get_node("workbench_screen/viewport/WorkbenchUi2d").play_shutdown.connect(func(): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		overwrite_player_interaction(false);
		)


func _on_body_entered(body: Player) -> void:
	overwrite_player_interaction(true)
	player.velocity = Vector3.ZERO
	look_at_workbench = true
	move_player_to_workbench()
	

func overwrite_player_interaction(mode: bool):
	get_tree().paused = mode
	player.paused = mode
	player.ui.visible = !mode
	player.weapon_controller.visible = !mode
	player.crosshair.visible = !mode
	

func move_player_to_workbench() -> void:
	var t : Tween = create_tween()
	var t2 : Tween = create_tween()
	
	t.set_ease(Tween.EASE_OUT_IN)
	t.tween_property(player, "global_position:x", marker_3d.global_position.x, 2)
	t.play()
	
	t2.set_ease(Tween.EASE_OUT_IN)
	t2.tween_property(player, "global_position:z", marker_3d.global_position.z, 2)
	t2.play()
	
	
	await t.finished
	look_at_workbench = false
	play_workbench_start.emit()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	


func _process(_delta: float) -> void:
	if look_at_workbench:
		player.look_at($"..".global_position + Vector3(0, 0.5, 0), Vector3.UP)
		
