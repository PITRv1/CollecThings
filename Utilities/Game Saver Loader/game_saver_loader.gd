class_name GameSaverLoader extends Node


@onready var player : Player = get_tree().get_first_node_in_group("player")

var main_volume : float
var music_volume : float
var window_mode : Window.Mode
var game_resolution : Vector2i
var safe_mode : int
var pixelization_amount : int
var pixelization_shader = null

var health_data : Dictionary = {}
var position_data : Dictionary = {}
var shield_data : Dictionary = {}

var picked_up_items : Array[NodePath] = []
var custom_map_data : Dictionary = {}

func _ready() -> void:
	Global.game_saver_loader = self
	if ResourceLoader.exists(Global.INV_SAVE_FILE):
		var inventory : Inventory = ResourceLoader.load(Global.INV_SAVE_FILE)
		if inventory:
			picked_up_items = inventory.picked_up_items
			if player:
				player.inventory = inventory.inventory
			
	
	pixelization_shader = Global.get_environment_shader_by_property("down_scaling")
	
	load_custom_map_data()
	load_settings()
	_handle_pickup_interaction()
	get_tree().create_timer(2, true, true, false).timeout.connect(_load_components)
	
	if Global.load_saved_map_data:
		get_tree().create_timer(0.2, true, true, false).timeout.connect(load_saved_map_data)
		Global.load_saved_map_data = false
	

func save_inventory() -> void:
	var inventory : Inventory = Inventory.new()
	inventory.picked_up_items = picked_up_items
	inventory.inventory = player.inventory
	
	ResourceSaver.save(inventory, Global.INV_SAVE_FILE)
	

func _handle_pickup_interaction() -> void:
	var scraps : Array[Node] = get_tree().get_nodes_in_group("scraps")
	
	for scrap : Scrap in scraps:
		if picked_up_items.has(scrap.get_path()): scrap.health_component.damage(1)
		scrap.health_component.died.connect(func(): _save_item(scrap.get_path()))
		
	var gunpowders : Array[Node] = get_tree().get_nodes_in_group("gunpowders")
	
	for gunpowder : Gunpowder in gunpowders:
		if picked_up_items.has(gunpowder.get_path()):gunpowder.health_component.damage(1)
		gunpowder.health_component.died.connect(func(): _save_item(gunpowder.get_path()))
	

func _save_item(path : NodePath):
	if picked_up_items.has(path): return
	else: picked_up_items.append(path)
	save_inventory()
	

func _load_components() -> void:
	var health_components : Array[Node] = get_tree().get_nodes_in_group("health_components")
	for health_component: HealthComponent in health_components:
		if health_data.has(health_component.get_path()): return
		health_data[health_component.get_path()] = health_component.health
		health_component.damaged.connect(func(): _handle_health_component_value_change(health_component))
		health_component.healed.connect(func(): _handle_health_component_value_change(health_component))
		
	
	var shield_components : Array[Node] = get_tree().get_nodes_in_group("shield_components")
	for shield_component: ShieldComponent in shield_components:
		if shield_data.has(shield_component.get_path()): return
		shield_data[shield_component.get_path()] = shield_component.shield
		shield_component.damaged.connect(func(): _handle_shield_component_value_change(shield_component))
		shield_component.healed.connect(func(): _handle_shield_component_value_change(shield_component))
		
	

func _handle_health_component_value_change(health_component: HealthComponent) -> void:
	var id : NodePath = health_component.get_path()
	health_data[id] = health_component.health
	

func _handle_shield_component_value_change(shield_component: ShieldComponent) -> void:
	var id : NodePath = shield_component.get_path()
	shield_data[id] = shield_component.shield
	

func _save_position_data() -> void:
	var health_components : Array[Node] = get_tree().get_nodes_in_group("health_components")
	for health_component: HealthComponent in health_components:
		position_data[health_component.get_parent().get_path()] = health_component.get_parent().global_position
		

func load_custom_map_data() -> void:
	if ResourceLoader.exists(Global.MAP_SAVE_FILE):
		var map_data : MapData = ResourceLoader.load(Global.MAP_SAVE_FILE)
		custom_map_data = map_data.custom_data

func save_current_map_data() -> void:
	_load_components()
	_save_position_data()
	
	var map_data : MapData = MapData.new()
	map_data.map_path = get_tree().current_scene.scene_file_path
	map_data.health_data = health_data
	map_data.shield_data = shield_data
	map_data.position_data = position_data
	map_data.player_position = player.global_position
	map_data.player_rotation = Vector2(player.camera.rotation.x, player.rotation.y)
	map_data.player_velocity = player.velocity
	map_data.inventory = player.inventory
	map_data.custom_data = custom_map_data
	
	ResourceSaver.save(map_data, Global.MAP_SAVE_FILE)
	Global.update_main_menu()
	

func save_custom_map_data(key: String, value) -> void:
	custom_map_data[key] = value
	save_current_map_data()


func load_saved_map():
	if ResourceLoader.exists(Global.MAP_SAVE_FILE):
		var map_path : String = ResourceLoader.load(Global.MAP_SAVE_FILE).map_path
		
		if map_path:
			Global.change_scene_to(map_path)
			Global.load_saved_map_data = true
	


func load_saved_map_data() -> void:
	if ResourceLoader.exists(Global.MAP_SAVE_FILE):
		var map_data : MapData = ResourceLoader.load(Global.MAP_SAVE_FILE)
		
		if map_data:
			if get_tree().current_scene.scene_file_path == map_data.map_path:
				
				health_data = map_data.health_data
				position_data = map_data.position_data
				shield_data = map_data.shield_data
				custom_map_data = map_data.custom_data
				
				var health_components : Array[Node] = get_tree().get_nodes_in_group("health_components")
				for health_component: HealthComponent in health_components:
					var id : NodePath = health_component.get_path()
					var parent := health_component.get_parent()
					
					if health_data.has(id):
						health_component.damage(health_component.health-health_data[id])
					
					if position_data.has(parent.get_path()):
						instance_from_id(parent.get_instance_id()).global_position = position_data[parent.get_path()]
				
				var shield_components : Array[Node] = get_tree().get_nodes_in_group("shield_components")
				for shield_component: ShieldComponent in shield_components:
					var id : NodePath = shield_component.get_path()
					
					if shield_data.has(id):
						shield_component.damage(shield_component.shield-shield_data[id])
				
				
				if player and player.camera:
					player.global_position = map_data.player_position
					player.camera.rotation.x = map_data.player_rotation[0]
					player.global_rotation.y = map_data.player_rotation[1]
					player.velocity = map_data.player_velocity
					player.inventory = map_data.inventory
					
				


func set_main_volume(volume: float) -> void: 
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), volume)
	main_volume = volume
	

func set_music_volume(volume: float) -> void:
	AudioPlayer.volume_db = volume
	AudioPlayer.default_volume = volume
	music_volume = volume
	

func set_window_mode(mode: Window.Mode) -> void:
	get_tree().root.mode = mode
	window_mode = mode
	

func set_game_resolution(resolution: Vector2i) -> void:
	get_tree().root.content_scale_size = resolution
	game_resolution = resolution
	

func set_safe_mode(value: int) -> void:
	if player:
		player.safe_mode.mode = value
		player.safe_mode.reload()
	safe_mode = value
	

func set_pixelization_amount(value: int) -> void:
	if pixelization_shader != null:
		pixelization_shader.set("down_scaling", value)
	pixelization_amount = value
	

func save_settings() -> void:
	Global.update_main_menu()
	var config_data : ConfigData = ConfigData.new()
	
	config_data.main_volume = main_volume
	config_data.music_volume = music_volume
	config_data.window_mode = window_mode
	config_data.resolution = game_resolution
	config_data.compatibility_mode = safe_mode
	config_data.pixelization = pixelization_amount
	
	ResourceSaver.save(config_data, Global.USER_SAVE_FILE)
	

func load_settings() -> void:
	var config_data : ConfigData = null
	
	if ResourceLoader.exists(Global.USER_SAVE_FILE):
		config_data = ResourceLoader.load(Global.USER_SAVE_FILE)
	else:
		config_data = ConfigData.new()
	
	
	if config_data:
		set_main_volume(config_data.main_volume)
		set_music_volume(config_data.music_volume)
		set_window_mode(config_data.window_mode)
		set_game_resolution(config_data.resolution)
		set_safe_mode(config_data.compatibility_mode)
		set_pixelization_amount(config_data.pixelization)
		
	
