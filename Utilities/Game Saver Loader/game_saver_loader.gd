class_name GameSaverLoader extends Node

var main_volume : float
var music_volume : float
var window_mode : Window.Mode
var game_resolution : Vector2i
var safe_mode : int
var pixelization_amount : int

@onready var player : Player = get_tree().get_first_node_in_group("player")

var pixelization_shader = null

func _ready() -> void:
	pixelization_shader = Global.get_environment_shader_by_property("down_scaling")
	load_settings()
	

func set_main_volume(volume: float) -> void: 
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	main_volume = volume
	

func set_music_volume(volume: float) -> void:
	AudioPlayer.volume_db = volume
	AudioPlayer.default_volume = volume
	music_volume = volume
	

func set_window_mode(mode: Window.Mode):
	get_tree().root.mode = mode
	window_mode = mode
	

func set_game_resolution(resolution: Vector2i):
	get_tree().root.content_scale_size = resolution
	game_resolution = resolution
	

func set_safe_mode(value: int):
	if player:
		player.safe_mode.mode = value
		player.safe_mode.reload()
	safe_mode = value
	

func set_pixelization_amount(value: int):
	if pixelization_shader != null:
		pixelization_shader.set("down_scaling", value)
	pixelization_amount = value
	

func save_settings() -> void:
	var config_data : ConfigData = ConfigData.new()
	config_data.main_volume = main_volume
	config_data.music_volume = music_volume
	config_data.window_mode = window_mode
	config_data.resolution = game_resolution
	config_data.compatibility_mode = safe_mode
	config_data.pixelization = pixelization_amount
	
	ResourceSaver.save(config_data, "user://game_settings.tres")
	

func load_settings() -> void:
	if ResourceLoader.exists("user://game_settings.tres"):
		var config_data : ConfigData = ResourceLoader.load("user://game_settings.tres")
		set_main_volume(config_data.main_volume)
		set_music_volume(config_data.music_volume)
		set_window_mode(config_data.window_mode)
		set_game_resolution(config_data.resolution)
		set_safe_mode(config_data.compatibility_mode)
		set_pixelization_amount(config_data.pixelization)
		
