extends CanvasLayer

@onready var color_rect : ColorRect = $ColorRect
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var animation_player_intro : AnimationPlayer = $"../AnimationPlayer"

func _ready() -> void:
	color_rect.visible = false
	if animation_player_intro.has_animation("intro") && animation_player_intro.animation_finished:
		animation_player.play("fade_black")
		

func transition() -> void:
	color_rect.visible = true
	animation_player.play("fade_black")
