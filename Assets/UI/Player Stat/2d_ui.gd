extends Control

@onready var healthbar : ProgressBar = $Margin/UI/Health/ProgressBar
@onready var player : Player = get_tree().current_scene.get_node("Player")
<<<<<<< Updated upstream:Assets/UI/2d_ui.gd
=======
@onready var label : Label = $Margin/UI/PlayerStats/Shield/Label
>>>>>>> Stashed changes:Assets/UI/Player Stat/2d_ui.gd

func _ready() -> void:
	healthbar.max_value = player.health


func _process(delta) -> void:
	healthbar.value = player.health
	
<<<<<<< Updated upstream:Assets/UI/2d_ui.gd
	
	
	
=======
>>>>>>> Stashed changes:Assets/UI/Player Stat/2d_ui.gd
