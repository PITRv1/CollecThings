extends PinJoint3D

var player

@onready var remote_transform := RemoteTransform3D.new()
@onready var rig: RigidBody3D = $"../RigidBody3D"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
