extends BaseWeapon


# bullet decal and the UI
@onready var shooting_particles: GPUParticles3D = $shooting
@onready var charging_particles: GPUParticles3D = $charging
@export var b_decal : PackedScene = preload("res://Assets/Models/Bullet/BulletDecal.tscn")
@onready var gun_utility : Polygon2D = get_tree().get_first_node_in_group("gun_utility")

# weapon stats
var charge := 0.0
var knock_force : float
var damage : float

func _ready() -> void:
	knock_force = weapon_settings.knockback_force
	mag_size = weapon_settings.mag_size
	max_mag_size = weapon_settings.mag_size
	damage = weapon_settings.damage
	
	charging_particles.emitting = false

func _process(delta: float) -> void:
	# If alt_fire is held down increase charge, btw delta is basically the amount of time that passed so 1 delta is 1 sec
	
	if Input.is_action_pressed("secondary_fire"):
		
		# Only increase charge if the gun has enough bullets
		if floor(charge) < mag_size:
			is_primary_enabled = false
			
			charging_particles.emitting = true
			charging_particles.amount = floor(charge)*2
			
			charge += delta * 2
			
			# UI
			gun_utility.set_texture_offset(Vector2(5-(charge*2), 0))
	
	# If not pressing it down, and charge is more than 0 do an alt fire
	if Input.is_action_just_released("secondary_fire") and charge > 0:
		charging_particles.emitting = false
		is_primary_enabled = true
		_secondary_fire()
	


func _secondary_fire() -> void:
	# Set UI
	gun_utility.set_texture_offset(Vector2(-5, 0))
	
	# Change the weapon setting from the normal
	weapon_settings.knockback_force += charge * 30
	weapon_settings.damage = damage * 1.5
	weapon_settings.stun_time = charge*weapon_settings.stun_time
	
	# Shoot with these settings
	var ray : Dictionary = run_ray_test(true, [])
	shooting_particles.emitting = true
	
	if ray.size() > 0:
		if ray["collider"] is HitboxComponent:
			ray["collider"].damage(weapon_settings)
	draw_line(ray)
	
	# Decrease back to normal
	mag_size = mag_size - floor(charge)
	charge = 0.0
	weapon_settings.stun_time = 0.0
	weapon_settings.knockback_force = knock_force
	weapon_settings.damage = damage
	if mag_size == 0:
		reload()
