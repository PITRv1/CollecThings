extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var health_bar : ProgressBar = $Margin/UI/PlayerStats/HealthPanel/Margin/VBox/ProgressBar
@onready var energy_bar : ProgressBar = $Margin/UI/PlayerStats/EnergyPanel/Margin/VBox/ProgressBar


func _ready() -> void:
	health_bar.max_value = player.health_component.MAX_HEALTH
	health_bar.value = player.health_component.health
	


func _process(_delta: float) -> void:
	health_bar.value = player.health_component.health
