extends Control

signal play_shutdown

@onready var player : Player = get_tree().get_first_node_in_group("player")

func _on_button_pressed() -> void:
	play_shutdown.emit()

func _ready() -> void:
	$VBoxContainer/CenterContainer/Control/Menu/Label.text = "You have: Insufficent resources"
	

func _process(_delta: float) -> void:
	if player.inventory.has("scraps") and player.inventory.has("gunpowders"):
		$VBoxContainer/CenterContainer/Control/Menu/Label.text = "You have: "+str(player.inventory["scraps"])+"x scrap(s), "+str(player.inventory["gunpowders"])+" x gunpowder(s)"
