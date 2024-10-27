extends Control

@onready var healthbar : ProgressBar = $Margin/UI/Health/ProgressBar
@onready var player : Player = get_tree().current_scene.get_node("Player")

func _ready():
	healthbar.max_value = player.health


func _process(delta):
	healthbar.value = player.health
	
	
	
	
