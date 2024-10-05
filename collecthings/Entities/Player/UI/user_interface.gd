extends Control

@onready var shader_layer: ColorRect = $ShaderLayer

func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shader_layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
