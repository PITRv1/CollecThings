extends BaseWeapon

@export var b_decal : PackedScene = preload("res://Assets/Models/Bullet/BulletDecal.tscn")
@onready var gun_utility = get_tree().get_first_node_in_group("gun_utility")

var charge : float
var knock_force : float
var damage : float

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	gun_utility.set_texture_offset(Vector2(0, 0))
	charge = 0.0
	knock_force = weapon_settings.knockback_force 
	clips = weapon_settings.mag_size
	damage = weapon_settings.damage

func _process(delta: float) -> void:
	if clips > 0:
		if Input.is_action_pressed("secondary_fire"):
			if floor(charge) < clips:
				charge += delta * 2
				gun_utility.set_texture_offset(Vector2(10-(charge*2), 0))
		elif charge > 0:
			_secondary_fire()
	else:
		if animation_player.has_animation("reload"):
			animation_player.play("reload")

func _secondary_fire():
	gun_utility.set_texture_offset(Vector2(0, 0))
	weapon_settings.knockback_force += charge * 30
	weapon_settings.damage += charge * 20
	spawn_bullet()
	clips = clips - floor(charge)
	print(charge)
	print(clips)
	charge = 0.0
	weapon_settings.knockback_force = knock_force
	weapon_settings.damage = damage
