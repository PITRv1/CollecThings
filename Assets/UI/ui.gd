extends Control

@onready var poslabel: Label = $HBoxContainer/VBoxContainer/pos
@onready var speedlabel: Label = $HBoxContainer/VBoxContainer/speed
var player = Global.player

func _process(delta) -> void:
	print(player.position)
	var posx: String = " x: "+str(int(player.position.x))
	var posy: String = " y: "+str(int(player.position.y))
	var posz: String = " z: "+str(int(player.position.z))
	poslabel.text = "Pos:"+posx+posy+posz
	
	speedlabel.text = "Speed:"+str(int(player.velocity))
	
