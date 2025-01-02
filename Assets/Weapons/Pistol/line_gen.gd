@tool

extends MeshInstance3D
@onready var burger: Node3D = $burger
@onready var end: Node3D = $end

@export var isDrawing : bool
var points : PackedVector3Array = []
var points_old : PackedVector3Array = []
@export var point_count : int = 20
var grapple_hook_position
var rope_length
var point_spacing
@export var dirty : bool
@export var firstTime : bool
var player_position
var vertex_array : Array
var normal_array : Array
var tangent_array : Array
var index_array : Array
@export var resolution : int = 4
@export var rope_width : float = 0.02
@export var iterations : int = 5
#@export var majon : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PreparePoints()
	UpdatePoints(0)
	GenerateMesh()
	var t = get_tree().create_tween()
	t.tween_property(self, "transparency", 1, 1)
	await t.finished
	queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func SetGrappleHookPosition(val : Vector3):
	grapple_hook_position = val
	firstTime = true
	
func SetPlayerPosition(val : Vector3):
	player_position = val

func StartDrawing():
	isDrawing = true
	
func StopDrawing():
	isDrawing = false
	
func PreparePoints():
	points.clear()
	points_old.clear()
	
	for i in range(point_count):
		var t = i / (point_count - 1.0)
		points.append(lerp(player_position, grapple_hook_position, t))
		points_old.append(points[i])
	
	_UpdatePointSpacing()

func _UpdatePointSpacing():
	rope_length = (grapple_hook_position - player_position).length()
	point_spacing = rope_length / (point_count - 1.0)
	
func UpdatePoints(delta):
	points[0] = player_position
	points[point_count-1] = grapple_hook_position
	
	_UpdatePointSpacing()
	
	for i in range(1, point_count - 1):
		var curr : Vector3 = points[i]
		#points[i] = points[i] + (points[i] - points_old[i]) + (
			#Vector3.DOWN * 9.8 * delta * delta
		#)
		points_old[i] = curr
		
	for i in range(iterations):
		ConstraintConnections()

func ConstraintConnections():
	for i in range(point_count - 1):
		var centre : Vector3 = (points[i+1] + points[i]) / 2.0
		var offset : Vector3 = (points[i+1] - points[i])
		var length : float = offset.length()
		var dir : Vector3 = offset.normalized()
		
		var d = length - point_spacing
		
		if i != 0:
			points[i] += dir * d * 0.5
		
		if i + 1 != point_count - 1:
			points[i+1] -= dir * d * 0.5
			
func GenerateMesh():
	
	vertex_array.clear()
	
	CalculateNormals()
	
	index_array.clear()
	
	for p in range(point_count):
		
		var center : Vector3 = points[p]
		
		var forward = tangent_array[p]
		var norm = normal_array[p]
		var bitangent = norm.cross(forward).normalized()
		
		for c in range(resolution):
			var angle = (float(c) / resolution) * 2.0 * PI
			
			var xVal = sin(angle) * rope_width
			var yVal = cos(angle) * rope_width
			
			var point = (norm * xVal) + (bitangent * yVal) + center
			
			vertex_array.append(point)
			
			if p < point_count - 1:
				var start_index = resolution * p
				
				index_array.append(start_index + c);
				index_array.append(start_index + c + resolution);
				index_array.append(start_index + (c + 1) % resolution);
				
				index_array.append(start_index + (c + 1) % resolution);
				index_array.append(start_index + c + resolution);
				index_array.append(start_index + (c + 1) % resolution + resolution);
	
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in range(index_array.size() / 3):
		var p1 = vertex_array[index_array[3*i]]
		var p2 = vertex_array[index_array[3*i+1]]
		var p3 = vertex_array[index_array[3*i+2]]
		
		var tangent = Plane(p1, p2, p3)
		var normal = tangent.normal
		
		mesh.surface_set_tangent(tangent)
		mesh.surface_set_normal(normal)
		mesh.surface_add_vertex(p1)
		
		mesh.surface_set_tangent(tangent)
		mesh.surface_set_normal(normal)
		mesh.surface_add_vertex(p2)
		
		mesh.surface_set_tangent(tangent)
		mesh.surface_set_normal(normal)
		mesh.surface_add_vertex(p3)
		
	mesh.surface_end()
	
func CalculateNormals():
	normal_array.clear()
	tangent_array.clear()
	
	var helper
	
	for i in range(point_count):
		var tangent := Vector3(0.0, 0.0, 0.0)
		var normal := Vector3(0.0, 0.0, 0.0)
		
		var temp_helper_vector := Vector3(0.0, 0.0, 0.0)
		
		if i == 0:
			tangent = (points[i+1] - points[i]).normalized()
		elif i == point_count - 1:
			tangent = (points[i] - points[i-1]).normalized()
		else:
			tangent = (points[i+1] - points[i]).normalized() + (points[i] - points[i-1]).normalized()
			
		if i == 0:
			temp_helper_vector = -Vector3.FORWARD if (tangent.dot(Vector3.UP) > 0.5) else Vector3.UP
			normal = temp_helper_vector.cross(tangent).normalized()
		else:
			var tangent_prev = tangent_array[i-1]
			var normal_prev = normal_array[i-1]
			var bitangent = tangent_prev.cross(tangent)
			
			if bitangent.length() == 0:
				normal = normal_prev
			else:
				var bitangent_dir = bitangent.normalized()
				var theta = acos(tangent_prev.dot(tangent))
				
				var rotate_matrix = Basis(bitangent_dir, theta)
				normal = rotate_matrix * normal_prev
				
		tangent_array.append(tangent)
		normal_array.append(normal)
