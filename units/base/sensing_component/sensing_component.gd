extends Node2D

class_name SensingComponent

@export var detectbox_area2d: Area2D

#@export var targetFactionId: int

var potentialTargets: Dictionary[UnitCore, bool] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	detectbox_area2d.body_entered.connect(_on_enter_detect_range)
	detectbox_area2d.body_exited.connect(_on_exit_detect_range)


func _on_enter_detect_range(body: UnitCore):
	if (get_parent() as UnitCore).faction_id != body.faction_id:
		potentialTargets.set(body, true)


func _on_exit_detect_range(body: UnitCore):
	potentialTargets.erase(body)


func get_potential_targets() -> Array[UnitCore]:
	return potentialTargets.keys()
