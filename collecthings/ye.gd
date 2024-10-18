extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D2
@onready var player: Player = %Player
@onready var colshape: CollisionShape3D = $CollisionShape3D2
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var audio2: AudioStreamPlayer3D = $AudioStreamPlayer3D2
@onready var timer: Timer = $Timer

var gravity = get_gravity()

func _physics_process(delta: float) -> void:
	
	var pos2d = Vector2(position.x, position.z)
	var playerpos2d = Vector2(player.position.x, player.position.z)
	var dir = -(pos2d - playerpos2d)
	rotation.y = lerp_angle(rotation.y, atan2(dir.x, dir.y), 1)
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_on_floor():
		nav_agent.set_target_position(player.position)
		var destination = nav_agent.get_next_path_position()
		var new_velocity = (destination - position).normalized() * 10.0
		velocity = velocity.move_toward(new_velocity, .25)
	move_and_slide()
	
	


func _on_hitbox_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		audio.stop()
		audio2.play()
		timer.start()
		body.look_sensitivity = 0
		body.ground_accel = 0

func _on_timer_timeout() -> void:
	get_tree().quit()
