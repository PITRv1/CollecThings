extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var full_shield : TextureRect = $Full

var shield_size_max : int 
var max_player_shield : int

func _ready() -> void:
	shield_size_max = full_shield.size.x
	max_player_shield = player.shield_component.MAX_SHIELD


func _process(delta: float) -> void:
	var current_player_shield = player.shield_component.shield
	
	var percent = (current_player_shield/max_player_shield)
	full_shield.size.x = shield_size_max*percent
	
