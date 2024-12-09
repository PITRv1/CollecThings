extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var health_bar : ProgressBar = $Margin/UI/PlayerStats/HealthPanel/Margin/VBox/ProgressBar
@onready var energy_bar : ProgressBar = $Margin/UI/PlayerStats/EnergyPanel/Margin/VBox/ProgressBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $MessagePanel/Margin/VBox/Label

var is_showing_message : bool = false
var message_list : Array = []

func _ready() -> void:
	Global.stat_tablet = self
	
	health_bar.max_value = player.health_component.MAX_HEALTH
	health_bar.value = player.health_component.health
			  

func _process(_delta: float) -> void:
	health_bar.value = player.health_component.health
	
	for message in message_list:
		_show_message(message, 4.0)

func purge_message(message: String):
	message_list.append(message)

func _show_message(message: String, time: float):
	if !is_showing_message:
		is_showing_message = true
		label.text = message
		animation_player.play("message_animation")
		get_tree().create_timer(time).timeout.connect(_hide_message.bind())
	

func _hide_message():
	animation_player.play_backwards("message_animation")
	get_tree().create_timer(1.5).timeout.connect(func():is_showing_message=false;message_list.pop_front())
	
