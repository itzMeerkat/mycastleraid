@tool
extends BTAction

var character_body: UnitCore = null


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Patrol"


# Called to initialize the task.
func _setup() -> void:
	character_body = self.agent as UnitCore


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	#print("movement ticking")
	var movement_component: MovementComponent = character_body.movement_component as MovementComponent
	if not is_instance_valid(movement_component):
		return FAILURE
		
	var wys = blackboard.get_var("waypoints") as Array[Vector2]
	var wp_idx = blackboard.get_var("waypoint_index") as int
	
	if wys.size() == 0:
		return FAILURE
	
	if movement_component.navigation_agent_2d.is_target_reached():
		if wp_idx < wys.size() - 1:
			wp_idx += 1
	
	blackboard.set_var("waypoint_index", wp_idx)

	movement_component.move_to(wys[wp_idx])
	return SUCCESS
