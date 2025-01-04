extends Node3D

@onready var player : Player = get_tree().get_first_node_in_group("player")
@export var play_animation : bool = false

func _ready() -> void:
	if play_animation:
		player.paused = true
		player.ui.visible = false
		player.weapon_controller.visible = false
		player.crosshair.visible = false
		
		$AnimationPlayer.play("wake_up")
	


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if $AnimationPlayer.is_playing():
			$AnimationPlayer.play("skip_anim")
			get_tree().create_timer(0.2).timeout.connect(_give_back_controls) 


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_give_back_controls()


func _give_back_controls() -> void:
	player.paused = false
	player.ui.visible = true
	player.weapon_controller.visible = true
	player.crosshair.visible = true
	
