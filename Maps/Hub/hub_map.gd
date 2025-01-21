extends Node3D


@export var play_animation : bool = false
@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var animation_player : AnimationPlayer = $Player/AnimationPlayer


func _ready() -> void:
	AudioPlayer.play_music(AudioPlayer.MUSIC_LIBRARY["Untitled"])
	
	if play_animation:
		player.paused = true
		player.ui.visible = false
		player.weapon_controller.visible = false
		player.crosshair.visible = false
		
		animation_player.play("wake_up")
		
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if animation_player.is_playing():
			animation_player.play("skip_anim")
			get_tree().create_timer(0.2).timeout.connect(_give_back_controls) 
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_give_back_controls()
	

func _give_back_controls() -> void:
	player.paused = false
	player.weapon_controller.visible = true
	player.ui.visible = true
	player.crosshair.visible = true
	
