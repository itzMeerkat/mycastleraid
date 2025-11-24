@tool
extends BTAction

# Task parameters.

var owner: UnitCore = null
var sensing_component: SensingComponent = null

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Obtain target"


# Called to initialize the task.
func _setup() -> void:
	owner = agent as UnitCore
	sensing_component = self.agent.sensing_component as SensingComponent


# Called when the task is entered.
func _enter() -> void:
	pass


# Called when the task is exited.
#func _exit() -> void:
	#character_body.isAttacking = false


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	if not is_instance_valid(sensing_component):
		return FAILURE
	#print("get target")
	var targets = sensing_component.get_potential_targets()
	var minDist: float = 9999999
	var minDistObj: UnitCore = null
	
	for v in targets:
		if not is_instance_valid(v):
			continue
		var d = owner.global_position.distance_squared_to(v.global_position)
		if d < minDist:
			minDist = d
			minDistObj = v
	
	blackboard.set_var("current_target", minDistObj)
	if minDistObj == null:
		return FAILURE
	return SUCCESS


# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
