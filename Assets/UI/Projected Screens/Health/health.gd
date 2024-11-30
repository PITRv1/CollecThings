extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var full_health : TextureRect = $Full

var health_size_max : int 
var max_player_health : int

func _ready() -> void:
	health_size_max = full_health.size.x
	max_player_health = player.health_component.MAX_HEALTH


func _process(delta: float) -> void:
	var current_player_health = player.health_component.health
	
	var percent = (current_player_health/max_player_health)
	full_health.size.x = health_size_max*percent
	
