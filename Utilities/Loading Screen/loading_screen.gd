extends Control

var scene_to_load: String = Global.next_scene

func _ready() -> void:
	ResourceLoader.load_threaded_request(scene_to_load)

func _process(delta: float) -> void:
	var progress = []
	
	ResourceLoader.load_threaded_get_status(scene_to_load, progress)
	$MarginContainer/VBoxContainer/ProgressBar.value = progress[0]*100
	
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(scene_to_load)
		get_tree().change_scene_to_packed(packed_scene)
