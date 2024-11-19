extends Node3D

var speed : float = 0.005

func _process(delta: float) -> void:
	$".".rotate_y(speed*delta)
	$".".rotate_x(speed*delta)
