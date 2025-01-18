extends CenterContainer


@export var dot_radius : float = 2.0
@export var dot_color : Color = Color.WHITE
@export var reticle_speed : float = 0.25
@export var reticle_distance : float = 0.5

@onready var reticle_lines : Array[Line2D] = [$Top, $Right, $Bottom, $Left]
@onready var player : Player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	queue_redraw()

func _process(_delta: float) -> void:
	adjust_reticle_lines()
	queue_redraw()
	

func _draw() -> void:
	draw_circle(Vector2(0,0), dot_radius, dot_color)


func change_crosshair_color(color: Color):
	for line in reticle_lines:
		line.default_color = color


func adjust_reticle_lines() -> void:
	var vel : Vector3 = player.get_real_velocity()
	var origin : Vector3 = Vector3(0,0,0)
	var pos : Vector2 = Vector2(0,0)
	var speed : float = origin.distance_to(vel)
	
	if speed > 25:
		speed = 25
	
	$Top.position = lerp($Top.position, pos+Vector2(0, -speed * reticle_distance), reticle_speed)
	$Right.position = lerp($Right.position, pos+Vector2(speed * reticle_distance, 0), reticle_speed)
	$Bottom.position = lerp($Bottom.position, pos+Vector2(0, speed * reticle_distance), reticle_speed)
	$Left.position = lerp($Left.position, pos+Vector2(-speed * reticle_distance, 0), reticle_speed)
	
	$ShieldUtility.position = lerp($ShieldUtility.position, pos+Vector2(-speed * reticle_distance, 0), reticle_speed)+Vector2(-2,0)
	$GunUtility.position = lerp($GunUtility.position, pos+Vector2(speed * reticle_distance, 0), reticle_speed)+Vector2(2,0)
	
