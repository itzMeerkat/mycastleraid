extends BTAction

func _tick(_delta: float) -> Status:
	var target = blackboard.get_var("current_target")
	if target == null:
		return FAILURE
	return SUCCESS
