extends Control

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var full_shield : TextureRect = $Full

var shield_size_max : int 

func _ready() -> void:
	shield_size_max = full_shield.size.x

func _process(delta: float) -> void:
	full_shield.size.x = shield_size_max*player.shield_component.shield_percent-1
	
