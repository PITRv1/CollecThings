extends Node

@onready var loading_screen : PackedScene = preload("res://Utilities/Loading Screen/LoadingScreen.tscn")
@onready var main_menu : PackedScene = preload("res://Maps/Main menu/Main_menu.tscn")

var stat_tablet : Control
var weapon_speacial : TextureRect
var player : Player
var next_scene: String

func change_scene_to(scene_path: String) -> void:
	if scene_path:
		next_scene = scene_path
		get_tree().change_scene_to_packed(loading_screen)
	

func change_weapon_special_icon(image: CompressedTexture2D) -> void:
	var file : Image = Image.load_from_file(image.resource_path)
	var texture : ImageTexture = ImageTexture.create_from_image(file)
	Global.weapon_speacial.texture = texture
	


func get_environment_shader_by_property(property: String) -> CompositorEffect:
	var world_env = get_tree().current_scene.get_node_or_null("WorldEnvironment") as WorldEnvironment
	if world_env:
		for effect in world_env.compositor.compositor_effects:
			if effect.get(property):
				return effect
	return null
	
