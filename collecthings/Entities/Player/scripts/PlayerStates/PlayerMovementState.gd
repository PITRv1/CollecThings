class_name PlayerMovementState

extends State

var player = Player
#var weapon : WeaponController

func _ready():
	await  owner.ready
	player = owner as Player
	#weapon = player.weapon_controller
