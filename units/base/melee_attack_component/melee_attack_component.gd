extends Node2D

class_name MeleeAttackComponent

@export var hitbox_area2d: Area2D
@export var hurtbox_area2d: Area2D


@export var base_damage: int
@export var base_attack_range: float


@export var base_cooldown: int

var lastAttackTime: int = 0

var owner_unit: UnitCore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	owner_unit = get_parent() as UnitCore


func can_attack(target: UnitCore) -> bool:
	var isCooldownFinished: bool = false
	var isInRange: bool = is_in_range(target)
	
	var currentTime = Time.get_ticks_msec()

	if currentTime - lastAttackTime >= base_cooldown:
		isCooldownFinished = true
	
	return isCooldownFinished and isInRange

func is_in_range(target: UnitCore) -> bool:
	return owner_unit.global_position.distance_squared_to(target.global_position) <= base_attack_range * base_attack_range
	
func start_cooldown():
	lastAttackTime = Time.get_ticks_msec()

func apply_damage(target: UnitCore):
	await Utils.random_delay(get_tree())
	var hits = hitbox_area2d.get_overlapping_areas()
	for a in hits:
		if a.get_parent().get_parent() == target:
			target._take_damage(base_damage)
			return
