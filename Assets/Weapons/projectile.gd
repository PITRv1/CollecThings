extends RayCast3D

@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var timer: Timer = $Timer
@onready var b_decal : PackedScene =  preload("res://Assets/Models/Bullet/BulletDecal.tscn")

var weapon_settings : WeaponSettings
var proj_speed : int
var pierce : int
var damage : float
var stun_time : float
var colliders : Array
var proj : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	proj_speed = weapon_settings.proj_speed
	pierce = weapon_settings.pierce
	damage = weapon_settings.damage
	stun_time = weapon_settings.stun_time
	proj = weapon_settings.projectile_mesh
	var pald = proj.instantiate()
	self.add_child(pald)
	

func enter(weapon_setting):
	weapon_settings = weapon_setting

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * proj_speed * delta
	target_position = Vector3.FORWARD * proj_speed * delta * 5.0
	
	force_raycast_update()
	
	if is_colliding() and get_collider() != player:
		
		if weapon_settings.hitscan == 1:
			if get_collider().has_method("damage") and get_collider() not in colliders:
				weapon_settings.global_pos = global_position
				weapon_settings.damage = damage
				weapon_settings.stun_time = stun_time
				get_collider().damage(weapon_settings)
				colliders.append(get_collider())
		
		if b_decal:
			var b = b_decal.instantiate()
			if b and get_collider() and not b.get_parent():
				get_collider().add_child(b)
				b.global_position = get_collision_point()
				b.look_at(get_collision_point() + get_collision_normal(), Vector3.UP)
		
		if not get_collider().has_method("damage") or pierce <= 0:
			queue_free()
		else:
			pierce -= 1

func _on_timer_timeout() -> void:
	queue_free()
