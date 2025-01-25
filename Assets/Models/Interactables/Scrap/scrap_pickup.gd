class_name Scrap extends Node3D

@onready var player : Player = get_tree().get_first_node_in_group("player")

@export var health_component : HealthComponent
@export var hitbox : Area3D

func _on_area_3d_body_entered(body: Player) -> void:
	if player.inventory.has("scraps"):
		player.inventory["scraps"] += 1
	else:
		player.inventory["scraps"] = 1
	
	health_component.damage(1)
	
