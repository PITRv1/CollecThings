extends Node2D

@onready var crosshair: Polygon2D = $Crosshair
@onready var player : Player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	var percent = 5-(player.shield_component.shield_percent*10)
	crosshair.set_texture_offset(Vector2(percent, 0))
	
