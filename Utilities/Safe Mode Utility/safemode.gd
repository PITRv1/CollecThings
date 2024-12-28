extends Node3D
class_name SafeMode

@export_enum("Automatic", "Disabled", "Performance", "Safe") var mode : int = 0

var unsupported_vendors : Array = ["Intel Corporation", ""]
var gpu : String = str(OS.get_video_adapter_driver_info()[0])
var resources_status : bool = true
var prev_mode : int = 0

func _ready() -> void:
	if ResourceLoader.exists(Global.USER_SAVE_FILE):
		var settings : ConfigData = ResourceLoader.load(Global.USER_SAVE_FILE)
		if settings:
			mode = settings.compatibility_mode
	
	if mode == 0:
		_check_graphics_card()
	reload()
	


func _process(_delta: float) -> void:
	#ISNT REALLY WORKING
	if prev_mode != mode:
		reload()
		prev_mode = mode
	


func reload():
	if mode == 0:
		push_warning("<<SAFE MODE has been set to AUTOMATIC MODE>>")
		_check_graphics_card()
		
	if mode == 1:
		push_warning("<<SAFE MODE has been disabled>>")
		resources_status = true
		_change_shaders_status()
	
	elif mode == 2:
		push_warning("<<PERFORMANCE MODE has been enabled>>")
		
	else:
		push_warning("<<SAFE MODE has been enabled for ", get_tree().current_scene.name, ">>")
		resources_status = false
		_change_shaders_status()
	
	Global.safe_mode_status = resources_status


func _check_graphics_card() -> void:
	if gpu in unsupported_vendors:
		mode = 3
		resources_status = false
	else:
		mode = 1
		resources_status = true


func _change_shaders_status() -> void:
	var world_env = Global.get_current_world_environment_node()
	
	if world_env and world_env.compositor:
		for effect in world_env.compositor.compositor_effects:
			effect.set("enabled", resources_status)
			push_warning("SAFEMODE -> ", effect, " has been set to ", resources_status)
	
