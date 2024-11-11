extends Node3D

@onready var timer: Timer = $Timer

@onready var remote_transform := RemoteTransform3D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	get_parent().add_child(remote_transform)
	remote_transform.global_transform = global_transform
	remote_transform.remote_path = remote_transform.get_path_to(self)
	


func _on_timer_timeout() -> void:
	queue_free()
