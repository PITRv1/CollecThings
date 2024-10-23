extends Control

@onready var poslabel: Label = $HBoxContainer/VBoxContainer/VBoxContainer2/pos
@onready var speedlabel: Label = $HBoxContainer/VBoxContainer/VBoxContainer2/speed
@onready var player: Player = get_tree().current_scene.get_node("Player")
@onready var timer: Timer = $Timer
func _ready() -> void:
	print(player)

func _process(delta) -> void:
	var posx: String = " x:"+str(int(player.position.x))
	var posy: String = " y:"+str(int(player.position.y))
	var posz: String = " z:"+str(int(player.position.z))
	poslabel.text = "Pos:"+posx+posy+posz
	

func _on_timer_timeout():
	speedlabel.text = "Speed:"+str(int(player.velocity.length()))
	timer.start()
