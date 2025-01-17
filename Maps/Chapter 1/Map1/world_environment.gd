extends WorldEnvironment

@onready var world_environment = $"."

@onready var environment_hub : Environment = preload("res://Assets/Environments/map1_environment.tres")
@onready var environment_map1 : Environment = preload("res://Assets/Environments/map1_environment_2.tres") 

func _on_area_3d_body_entered(_body : Player):
	world_environment.environment = environment_map1

func _on_area_3d_body_exited(_body : Player) -> void: 
	world_environment.environment = environment_hub
	
	

	
  
