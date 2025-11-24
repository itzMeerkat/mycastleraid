@tool
extends BTAction

# Task parameters.
var character_body: UnitCore = null

## Note: Each method declaration is optional.
## At minimum, you only need to define the "_tick" method.


# Called to generate a display name for the task (requires @tool).
func _generate_name() -> String:
	return "Melee Attack"


# Called to initialize the task.
func _setup() -> void:
	character_body = self.agent as UnitCore


# Called when the task is entered.
func _enter() -> void:
	pass
	#character_body.hitbox.monitoring = true
	## Force stop character
	#print("rua")
	##character_body.velocity = Vector2.ZERO
	#character_body.isAttacking = true
	#character_body.isRunning = false


# Called when the task is exited.
#func _exit() -> void:
	#print("rua2")
	#character_body.isAttacking = false


# Called each time this task is ticked (aka executed).
func _tick(_delta: float) -> Status:
	var atk_component = character_body.melee_attack_component as MeleeAttackComponent
	if not is_instance_valid(atk_component):
		return FAILURE
	
	var target = blackboard.get_var("current_target")
		
	if atk_component.can_attack(target):
		#return FAILURE
		atk_component.start_cooldown()
		character_body.begin_attack_animation()
	# initiate attack
	return SUCCESS


# Strings returned from this method are displayed as warnings in the editor.
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()
	return warnings
