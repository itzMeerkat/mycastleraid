extends Node2D

@export var faction_id: int
@export var waypointsObjs: Array[Node2D]

var waypoints: Array[Vector2] = []

var countdownManager = CountdownByFrame.new()
var warriorScene = preload("res://units/army/warrior/warrior.tscn")

var max_spawn = 2
var k = 0

func _ready() -> void:
	countdownManager.RegisterNewCountdown("spawn", 2, true)
	for o in waypointsObjs:
		waypoints.append(o.global_position)


func _process(delta: float) -> void:
	countdownManager.Update(delta)
	if countdownManager.IsTrigger("spawn"):
		var inst = warriorScene.instantiate() as Warrior
		inst.faction_id = faction_id
		inst.waypoints = waypoints
		add_child(inst)
		k+=1
		
		#countdownManager.SetEnable("spawn", false)
