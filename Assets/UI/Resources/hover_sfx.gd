extends Control

@onready var click_sfx : AudioStreamMP3 = preload("res://Assets/Sounds/click.mp3")

func _ready() -> void:
	set_click_sfx_for_buttons(get_parent())
	

func set_click_sfx_for_buttons(node) -> void:
	var children : Array = node.get_children()
	
	if children:
		for child in children:
			if child is Button:
				child.mouse_entered.connect(play_hover_sfx)
			elif child is HSlider:
				child.value_changed.connect(func(value): play_hover_sfx())
			set_click_sfx_for_buttons(child)
		


func play_hover_sfx() -> void:
	AudioPlayer.create_new_audio_player(click_sfx)
	
