class_name DeadPlayerState

extends PlayerMovementState

func enter(_previous_state):
	print("died")
	Engine.time_scale = 0.0
