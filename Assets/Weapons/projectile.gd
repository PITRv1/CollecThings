extends RayCast3D

var player : Player
var b_decal
var weapon_settings
var proj_speed
var pierce : int
@onready var timer: Timer = $Timer
var damage : float

var colliders : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	b_decal = preload("res://Assets/Models/BulletDecal.tscn")
	proj_speed = weapon_settings.proj_speed
	pierce = weapon_settings.pierce
	damage = weapon_settings.damage
	
func enter(weapon_setting):
	weapon_settings = weapon_setting
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * proj_speed * delta
	target_position = Vector3.FORWARD * proj_speed * delta * 10.0
	
	force_raycast_update()
	
	if is_colliding() and get_collider() != player:
		
		if weapon_settings.hitscan == 1:
			if get_collider().has_method("damage") and get_collider() not in colliders:
				weapon_settings.global_pos = global_position
				weapon_settings.damage = damage
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
