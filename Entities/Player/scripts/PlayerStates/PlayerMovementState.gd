class_name PlayerMovementState

extends State

var player = Player
var weapon : WeaponController
var healt_component : HealthComponent

func _ready():
	await  owner.ready
	player = owner as Player
	weapon = player.weapon_controller
	healt_component = player.health_component
	healt_component.died.connect(player_died)

func player_died()->void:
	print("my guy u literally dead")
