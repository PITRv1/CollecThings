class_name GameSaverLoader extends Node

var main_volume : float
var music_volume : float
var window_mode : Window.Mode
var game_resolution : Vector2i
var safe_mode : int
var pixelization_amount : int

var pixelization_shader = null
var health_data : Dictionary = {}

@onready var player : Player = get_tree().get_first_node_in_group("player")


func _ready() -> void:
	pixelization_shader = Global.get_environment_shader_by_property("down_scaling")
	_load_settings()
	get_tree().create_timer(0.5, true, true, false).timeout.connect(_load_health_components)
	


func _load_health_components():
	var health_components : Array[Node] = get_tree().get_nodes_in_group("health_components")
	for health_component: HealthComponent in health_components:
		health_component.damaged.connect(func(): _handle_health_component_damage(health_component))
		
		health_data[health_component.get_path()] = health_component.health
	print("<", get_tree().current_scene.name, "> map's health data: ", health_data)


func _handle_health_component_damage(health_component: HealthComponent):
	var id := health_component.get_path()
	
	health_data[id] = health_component.health
	print(id, " -> ", health_data[id], "hp")


func _save_current_map_data():
	var map_data : MapData = MapData.new()
	map_data.map_name = get_tree().current_scene.name
	map_data.health_data = health_data
	
	ResourceSaver.save(map_data, Global.MAP_SAVE_FILE)


func _load_saved_map_data():
	if ResourceLoader.exists(Global.MAP_SAVE_FILE):
		var map_data : MapData = ResourceLoader.load(Global.MAP_SAVE_FILE)
		
		if map_data:
			if get_tree().current_scene.name == map_data.map_name:
				print("Loading saved map data...")
				health_data = map_data.health_data
				
				var health_components : Array[Node] = get_tree().get_nodes_in_group("health_components")
				for health_component: HealthComponent in health_components:
					var id := health_component.get_path()
					
					health_component.damage(null, health_component.health-health_data[id])
				#
				print("Loaded saved map data succesfully")

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
	

func _save_settings() -> void:
	var config_data : ConfigData = ConfigData.new()
	config_data.main_volume = main_volume
	config_data.music_volume = music_volume
	config_data.window_mode = window_mode
	config_data.resolution = game_resolution
	config_data.compatibility_mode = safe_mode
	config_data.pixelization = pixelization_amount
	
	ResourceSaver.save(config_data, Global.USER_SAVE_FILE)
	

func _load_settings() -> void:
	if ResourceLoader.exists(Global.USER_SAVE_FILE):
		var config_data : ConfigData = ResourceLoader.load(Global.USER_SAVE_FILE)
		
		if config_data:
			set_main_volume(config_data.main_volume)
			set_music_volume(config_data.music_volume)
			set_window_mode(config_data.window_mode)
			set_game_resolution(config_data.resolution)
			set_safe_mode(config_data.compatibility_mode)
			set_pixelization_amount(config_data.pixelization)
		
		
