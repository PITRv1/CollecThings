extends Node

@export var inital_state : States

var current_state : States
var states: Dictionary = {}

@export var initial : String = "idle"

func _ready():
	for child in get_children():
		if child is States:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			
	if inital_state:
		inital_state.Enter(initial)
		current_state = inital_state
			
func _process(delta: float):
	if current_state:
		current_state.Update(delta)
		
func _physics_process(delta: float):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name):
	
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	if current_state:
		current_state.Exit()
	
	new_state.Enter(state.name.to_lower())
	
	current_state = new_state
