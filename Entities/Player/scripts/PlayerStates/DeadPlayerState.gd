class_name DeadPlayerState

extends PlayerMovementState

func enter(_previous_state):
	print("died")
	Global.player.queue_free()
