extends Node2D

class_name MovementComponent

@export var character_body: CharacterBody2D
@export var baseSpeed: float

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

var current_target: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_agent_2d.velocity_computed.connect(_velocity_computed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:

	navigation_agent_2d.target_position = current_target
	var next_path = navigation_agent_2d.get_next_path_position()
	var new_velo = character_body.global_position.direction_to(next_path) * baseSpeed
	
	if navigation_agent_2d.is_navigation_finished():
		return

	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velo)
	else:
		_velocity_computed(new_velo)
	character_body.move_and_slide()


func move_to(target: Vector2):
	current_target = target


func _velocity_computed(safe_velocity: Vector2):
	character_body.velocity = safe_velocity
