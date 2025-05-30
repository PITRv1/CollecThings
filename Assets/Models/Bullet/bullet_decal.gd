extends Node3D

@onready var timer: Timer = $Timer

@onready var remote_transform : RemoteTransform3D = RemoteTransform3D.new()

func _ready() -> void:
	call_deferred("_setup_remote_transform")

func _setup_remote_transform() -> void:
	if get_parent():
		get_parent().add_child(remote_transform)
		remote_transform.global_transform = global_transform
		remote_transform.remote_path = remote_transform.get_path_to(self)

func _on_timer_timeout() -> void:
	queue_free()
