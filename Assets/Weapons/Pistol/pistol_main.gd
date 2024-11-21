extends BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/BulletDecal.tscn")

var charge : float
var knock_force : float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	charge = 0.0
	knock_force = weapon_settings.knockback_force 

func _process(delta: float) -> void:
	if clips > 0:
		if Input.is_action_pressed("secondary_fire"):
			if floor(charge) < clips:
				charge += delta
		elif charge > 0:
			_secondary_fire()
	else:
		if animation_player.has_animation("reload"):
			animation_player.play("reload")
	print(charge)

func _secondary_fire():
	weapon_settings.knockback_force += charge * 30
	spawn_bullet()
	clips = 0
	charge = 0.0
	weapon_settings.knockback_force = knock_force
