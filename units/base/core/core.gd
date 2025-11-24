extends CharacterBody2D

class_name UnitCore

signal hp_change(float)

var max_health: float = 30
var health: float = max_health

var faction_id: int = 0


func _take_damage(amount: float):
	health -= amount
	emit_signal("hp_change", health)
	if health <= 0:
		_on_death()

func _get_target():
	pass

func _on_death():
	queue_free()
