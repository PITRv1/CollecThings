extends  BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/BulletDecal.tscn")

var charge : float

#func _ready() -> void:
	#player = get_tree().get_first_node_in_group("player")
	#charge = 0.0
	#clips = weapon_settings.mag_size

#func _process(delta: float) -> void:
	#if Input.is_action_pressed("secondary_fire"):
		#charge += delta
	#print(charge)
