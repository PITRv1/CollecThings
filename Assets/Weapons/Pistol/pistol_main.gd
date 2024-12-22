extends BaseWeapon

# bullet decal and the UI

@export var b_decal : PackedScene = preload("res://Assets/Models/Bullet/BulletDecal.tscn")
@onready var gun_utility = get_tree().get_first_node_in_group("gun_utility")

# weapon stats

var charge := 0.0
var knock_force : float
var damage : float

func _ready() -> void:
	
	# Set up the player and the UI
	
	player = get_tree().get_first_node_in_group("player")
	gun_utility.set_texture_offset(Vector2(-5, 0))
	
	# Save the base weapon settings for later use
	
	knock_force = weapon_settings.knockback_force 
	mag_size = weapon_settings.mag_size
	max_mag_size = weapon_settings.mag_size
	damage = weapon_settings.damage

func _process(delta: float) -> void:

	# If alt_fire is held down increase charge, btw delta is basically the amount of time that passed so 1 delta is 1 sec

	if Input.is_action_pressed("secondary_fire"):
		
		# Only increase charge if the gun has enough bullets
		
		print(Engine.time_scale)
		
		if floor(charge) < mag_size:
			
			charge += delta * 2
			
			# UI
			
			gun_utility.set_texture_offset(Vector2(10-(charge*2), 0))
	
	# If not pressing it down, and charge is more than 0 do an alt fire
	
	elif charge > 0:
		
		_secondary_fire()

func _secondary_fire():
	
	# Set UI
	
	gun_utility.set_texture_offset(Vector2(0, 0))
	
	# Change the weapon setting from the normal
	
	weapon_settings.knockback_force += charge * 30
	weapon_settings.damage += charge * 20
	weapon_settings.stun_time = charge / 2
	
	# Spawn the bullet with these settings
	
	spawn_bullet()
	
	# Decrease back to normal
	
	mag_size = mag_size - floor(charge)
	print(charge)
	print(mag_size)
	charge = 0.0
	weapon_settings.stun_time = 0.0
	weapon_settings.knockback_force = knock_force
	weapon_settings.damage = damage
	if mag_size == 0:
		reload()
