extends CharacterBody3D

var player : CharacterBody3D = null
var state_machine

@export var player_path : NodePath
@export var idle : bool

var stun_time := 0.0

const SPEED = 10.0
const ATTACK_RANGE = 2.5

@export var damage := 20.0
@onready var rays: RayCast3D = $RayCast3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree: AnimationTree = $"States and animation/AnimationTree"
@onready var ray: RayCast3D = $RayCasts/sight
@onready var chase_timer: Timer = $Timers/chaseTimer
@onready var wander_timer: Timer = $Timers/wanderTimer
var chase_dis = 50.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	state_machine = anim_tree.get("parameters/playback")

func _physics_process(delta: float) -> void:
	
	match state_machine.get_current_node():
		"falling":
			velocity += get_gravity() * delta
		"idle":
			velocity = Vector3.ZERO
		"wander":
			# Navigation
			if wander_timer.is_stopped():
				nav_agent.set_target_position(global_position + Vector3(randf_range(-16, 16), 0.0, randf_range(-16, 16)))
				wander_timer.start()

			# Rotation
			if !nav_agent.is_target_reached():
				var direction = global_position.direction_to(nav_agent.get_next_path_position())
				rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), 5 * delta)
			
			# Movement
			if nav_agent.distance_to_target() > 0.5:
				var destination = nav_agent.get_next_path_position()
				var new_velocity = (destination - global_position).normalized() * 2.5
				velocity = velocity.move_toward(new_velocity, .25)
			else:
				velocity = lerp(velocity, Vector3(0.0, velocity.y, 0.0), .25)
			
			if rays.is_colliding():
				velocity = Vector3.ZERO
			
	#Conditions
	anim_tree.get("parameters/playback")

	move_and_slide()
	
func _is_reachable():
	if !nav_agent.is_target_reachable():
		return true

func _randomize_wander():
	nav_agent.set_target_position(global_position + Vector3(randf_range(-4, 4), 0.0, randf_range(-4, 4)))
