extends HBoxContainer

@onready var player : Player = get_tree().get_first_node_in_group("player")

@export var crafting_ingredients : Dictionary
@export var item_name : String

func _on_craft_button_pressed() -> void:
	var can_craft : bool = true
	for item in crafting_ingredients:
		if player.inventory.has(item):
			var amount_of_item_available : int = player.inventory.get(item)
			var amount_of_item_needed : int = crafting_ingredients.get(item)
			var diff : int = amount_of_item_available - amount_of_item_needed
			
			if diff < 0:
				can_craft = false
	
	if can_craft:
		if player.inventory.has("items"):
			if !player.inventory["items"].has(item_name):
				player.inventory["items"].append(item_name)
		else:
			player.inventory["items"] = [item_name]
			
		for item in crafting_ingredients:
				var amount_of_item_available : int = player.inventory.get(item)
				var amount_of_item_needed : int = crafting_ingredients.get(item)
				var diff : int = amount_of_item_available - amount_of_item_needed
				player.inventory[item] = diff
				
		Global.game_saver_loader.save_inventory()
		queue_free()
