class_name PlayerStateMachine

extends Node

@export var CURRENT_STATE : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transition.connect(on_child_transition)
		else:
			push_warning("State machine contains incompatible child")
		
	await owner.ready
	CURRENT_STATE.enter(CURRENT_STATE)
	
func _process(delta):
	CURRENT_STATE.update(delta)

func _physics_process(delta):
	CURRENT_STATE.physics_update(delta)
	
func on_child_transition(new_state_name: StringName)->void:
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit()
			new_state.enter(CURRENT_STATE)
			#print("------------")
			#print(new_state)
			#print("------------")
			CURRENT_STATE = new_state
	else:
		push_warning("State does not exist")
