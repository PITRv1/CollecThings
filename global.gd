extends Node


@onready var main_menu : PackedScene = null
@onready var space_main_menu : PackedScene = preload("res://Maps/Main_Menu/Space/Main_menu.tscn")
@onready var crashed_main_menu : PackedScene = preload("res://Maps/Main_Menu/Crash/Main_menu.tscn")
@onready var loading_screen : PackedScene = preload("res://Utilities/Loading Screen/LoadingScreen.tscn")


const USER_SAVE_FILE : String = "user://game_settings.tres"
const MAP_SAVE_FILE : String = "user://mapdata_save.tres"
const INV_SAVE_FILE : String = "user://item_save.tres"


var weapon_speacial : TextureRect
var stat_tablet : StatTablet
var player : Player
var next_scene: String
var safe_mode_status : bool
var load_saved_map_data : bool = false
var game_saver_loader : GameSaverLoader

func _ready() -> void:
	update_main_menu()


func update_main_menu() -> void:
	Global.main_menu = Global.space_main_menu
	
	if ResourceLoader.exists(Global.MAP_SAVE_FILE):
		var map_data : MapData = ResourceLoader.load(Global.MAP_SAVE_FILE)
		
		if map_data.map_path != "res://Maps/Tutorial Map/tutorial_level.tscn":
			Global.main_menu = Global.crashed_main_menu
			


func change_scene_to(scene_path: String) -> void:
	if scene_path:
		next_scene = scene_path
		get_tree().change_scene_to_packed(loading_screen)
	


func get_current_world_environment_node() -> WorldEnvironment:
	var world_env = get_tree().current_scene.get_node_or_null("WorldEnvironment") as WorldEnvironment
	
	if world_env:
		return world_env
	return null
	


func get_environment_shader_by_property(property: String) -> CompositorEffect:
	var world_env = get_current_world_environment_node() as WorldEnvironment
	if world_env and world_env.compositor:
		for effect in world_env.compositor.compositor_effects:
			if effect.get(property):
				return effect
	return null
	

func create_weapon_setting_to_damage(damage : float) -> WeaponSettings:
	var Weaponsetting := WeaponSettings.new()
	Weaponsetting.damage = damage
	
	return Weaponsetting
	
