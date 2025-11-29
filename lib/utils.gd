extends Node

class_name Utils

static func random_delay(tree: SceneTree):
	var delay = randf_range(Consts.ATTACK_DELAY_MIN, Consts.ATTACK_DELAY_MAX)
	await tree.create_timer(delay).timeout
