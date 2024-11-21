extends Node3D

@export var move_speed: float = 5.0
@export var turn_speed: float = 1.0
@export var ground_offset: float = 0.5

@onready var fl_leg = $FrontLeftIKTarget
@onready var fr_leg = $FrontRightIKTarget

@onready var bl_leg = $BackLeftIKTarget
@onready var br_leg = $BackRightIKTarget
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@export var player : Node3D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	var plane1 = Plane(bl_leg.global_position, fl_leg.global_position, fr_leg.global_position)
	var plane2 = Plane(fr_leg.global_position, br_leg.global_position, bl_leg.global_position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, move_speed * delta).orthonormalized()
	
	var avg = (fl_leg.position + fr_leg.position + bl_leg.position + br_leg.position) / 4
	var target_pos = avg + transform.basis.y * ground_offset
	var distance = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * distance, move_speed * delta)
	
	_handle_movement(delta)
	
func _handle_movement(delta):
	nav_agent.set_target_position(player.global_position)
	var dir = Input.get_axis('ui_down', 'ui_up')
	var direction = global_position.direction_to(nav_agent.target_position)
	var facing = global_transform.basis.tdotz(direction)
	dir = -facing
	if ray_cast_3d.is_colliding():
		translate(Vector3(0, 0, -dir) * move_speed * delta)
	
	var a_dir = Input.get_axis('ui_right', 'ui_left')
	direction = global_position.direction_to(nav_agent.target_position)
	facing = global_transform.basis.tdotx(direction)
	a_dir = -facing
	rotate_object_local(Vector3.UP, a_dir * turn_speed * delta)

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)

	result = result.orthonormalized()
	result.x *= scale.x 
	result.y *= scale.y 
	result.z *= scale.z 
	
	return result
