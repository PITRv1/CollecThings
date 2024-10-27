extends AnimationPlayer


@onready var animation_player_2 = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player_2.play("gear_rotation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
