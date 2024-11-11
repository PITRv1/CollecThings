extends CharacterBody3D

var player : CharacterBody3D = null
var state_machine

@export var player_path : NodePath
@export var idle : bool

const SPEED = 10.0
const ATTACK_RANGE = 2.5

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree: AnimationTree = $"States and animation/AnimationTree"
@onready var ray: RayCast3D = $RayCasts/sight
@onready var chase_timer: Timer = $Timers/chaseTimer
@onready var wander_timer: Timer = $Timers/wanderTimer
var chase_dis = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		pass
		#velocity.y += 5.0
		#player.velocity.y += 5.0
	elif Input.is_action_pressed("sprint"):
		velocity.y -= 50.0
		#player.velocity.y -= 50
	

func _physics_process(delta: float) -> void:
	
	match state_machine.get_current_node():
		"falling":
			velocity += get_gravity() * delta
		"idle":
			velocity = Vector3.ZERO
		"wander":
			
			# Navigation
			if wander_timer.is_stopped():
				nav_agent.set_target_position(global_position + Vector3(randf_range(-4, 4), 0.0, randf_range(-4, 4)))
				wander_timer.start()

			# Rotation
			if !nav_agent.is_target_reached():
				var direction = global_position.direction_to(nav_agent.get_next_path_position())
				rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), 5 * delta)
			
			# Movement
			if nav_agent.distance_to_target() > 0.5:
				var destination = nav_agent.get_next_path_position()
				var new_velocity = (destination -global_position).normalized() * 2.5
				velocity = velocity.move_toward(new_velocity, .25)
			else:
				velocity = lerp(velocity, Vector3(0.0, velocity.y, 0.0), .25)
				
		"chase":
			# Rotation
			var direction = global_position.direction_to(player.global_position + velocity)
			rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), 5 * delta)
			
			# Movement
			nav_agent.set_target_position(player.global_position)
			var destination = nav_agent.get_next_path_position()
			var new_velocity = (destination -global_position).normalized() * 5.0
			velocity = velocity.move_toward(new_velocity, .25)
			
		"attack":
			velocity = lerp(velocity, Vector3(0.0, 0.0, 0.0), .25)
			var direction = global_position.direction_to(player.global_position)
			rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), 20 * delta)
	
	#Conditions
	anim_tree.set("parameters/conditions/fall_wand", is_on_floor())
	anim_tree.set("parameters/conditions/falling", !is_on_floor())
	anim_tree.set("parameters/conditions/idle", idle and is_on_floor())
	anim_tree.set("parameters/conditions/wander", is_on_floor() and !_target_in_sight() and chase_timer.is_stopped())
	anim_tree.set("parameters/conditions/attack", _target_in_range() and _target_in_sight())
	anim_tree.set("parameters/conditions/run", (_target_in_sight() or !chase_timer.is_stopped()) and !_target_in_range() and is_on_floor())
	anim_tree.get("parameters/playback")
	
	
	move_and_slide()
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _target_in_sight():
	if global_position.distance_to(player.global_position) < 1.5:
		chase_timer.start()
		return true
	
	elif global_position.distance_to(player.global_position) < 25.0:
		ray.target_position.z = -global_position.distance_to(player.global_position)
		ray.look_at(player.global_position, Vector3.UP)
		ray.force_raycast_update()
		var direction = global_position.direction_to(player.global_position)
		var facing = global_transform.basis.tdotz(direction)
		var fov = cos(deg_to_rad(30))
		if facing > fov and not ray.is_colliding():
			chase_timer.start()
			return true
	
func _hit_finished():
	pass
	
func _randomize_wander():
	nav_agent.set_target_position(global_position + Vector3(randf_range(-4, 4), 0.0, randf_range(-4, 4)))

func _on_area_3d_body_entered(body: Node3D) -> void:
	print(body)
	if body == player:
		var dir = global_position.direction_to(player.global_position)
		player.velocity += dir * 40.0
