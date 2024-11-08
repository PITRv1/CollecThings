extends Control

@onready var healthbar : ProgressBar = $Margin/UI/PlayerStats/Health/ProgressBar
@onready var player : Player = get_tree().current_scene.get_node("Player")
@onready var label = $Margin/UI/PlayerStats/Shield/Label

func _ready():
	healthbar.max_value = player.health


func _process(delta):
	healthbar.value = player.health
	
	
	
	
func _on_button_pressed():
	if Engine.time_scale == 1:
		Engine.time_scale =  0
	else:
		Engine.time_scale = 1
