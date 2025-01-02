@tool
extends Camera3D

@onready var space_ship: Node3D = $"../Space_ship/Space_ship"

func _process(delta: float) -> void:
	self.look_at(space_ship.global_position, Vector3.UP)
