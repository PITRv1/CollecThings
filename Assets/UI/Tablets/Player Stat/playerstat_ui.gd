extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var health_bar : ProgressBar = $Margin/UI/PlayerStats/HealthPanel/Margin/VBox/ProgressBar
@onready var shield_bar : ProgressBar = $Margin/UI/PlayerStats/ShieldPanel/Margin/VBox/ProgressBar


func _ready() -> void:
	health_bar.max_value = player.health_component.MAX_HEALTH
	health_bar.value = player.health_component.health
	
	shield_bar.max_value = player.shield_component.MAX_SHIELD
	shield_bar.value = player.shield_component.shield


func _process(_delta: float) -> void:
	health_bar.value = player.health_component.health
	shield_bar.value = player.shield_component.shield
