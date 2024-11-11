extends "res://Assets/Weapons/base_weapon.gd"

@onready var b_decal
@onready var marker_3d: Marker3D = $Marker3D

func _ready() -> void:
	b_decal = preload("res://Assets/Models/BulletDecal.tscn")
	player = get_tree().get_first_node_in_group("player")
