extends Control

@onready var player : Player = get_tree().current_scene.get_node("Player") 
@onready var health_bar : ProgressBar = $Margin/UI/PlayerStats/HealthPanel/Margin/VBox/ProgressBar
@onready var shield_bar : ProgressBar = $Margin/UI/PlayerStats/ShieldPanel/Margin/VBox/ProgressBar


func _ready() -> void:
	var player_health : int = player.health
	var player_shield : int = player.shield
	
	health_bar.max_value = player_health
	health_bar.value = player_health
	
	shield_bar.max_value = player_shield
	shield_bar.value = player_shield


func _process(delta: float) -> void:
	health_bar.value = player.health
	shield_bar.value = player.shield
	
	if Input.is_action_just_pressed("sprint"):
		player.health -= 20
		player.shield -= 20
