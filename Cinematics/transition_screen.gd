extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var animation_player_intro = $"../AnimationPlayer"

func _ready():
	color_rect.visible = false
	if animation_player_intro.has_animation("intro") && animation_player_intro.animation_finished:
		animation_player.play("fade_black")
		
		
func transition():
	color_rect.visible = true
	animation_player.play("fade_black")
