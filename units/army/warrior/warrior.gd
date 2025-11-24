extends UnitCore

class_name Warrior

#signal damaged(amt)
#signal killed(obj: BaseCombatUnit)

@onready var _sprite2d = $Sprite2D
@onready var hp_bar: ProgressBar = $"HP Bar"
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var bt_player: BTPlayer = $BTPlayer

@onready var sensing_component: Node2D = $SensingComponent as SensingComponent
@onready var movement_component: Node2D = $MovementComponent as MovementComponent
@onready var melee_attack_component: Node2D = $MeleeAttackComponent as MeleeAttackComponent


const tombStone = preload("res://prefabs/tomb_stone/tomb_stone.tscn")
@onready var sprite_2d: Sprite2D = $Sprite2D

var waypoints: Array[Vector2]

# animation conditions
var is_attacking: bool = false
var is_running: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#super()
	#navigation_agent_2d.velocity_computed.connect(_velocity_computed)

	#detectionRangeHitbox.body_entered.connect(_on_enter_detect_range)
	#detectionRangeHitbox.body_exited.connect(_on_exit_detect_range)
	hp_change.connect(onHpChange)
	hp_bar.value=health
	
	bt_player.blackboard.set_var("waypoints", waypoints)
	bt_player.blackboard.set_var("waypoint_index", 0)
	

func flipSpriteCheck():
	var target = bt_player.blackboard.get_var("current_target",null,false)
	if not velocity.is_zero_approx() and target == null:
		if velocity.x < 0:
			_sprite2d.scale.x = -1
		if velocity.x > 0:
			_sprite2d.scale.x = 1
	elif target != null:
		if target.global_position.x < global_position.x:
			_sprite2d.scale.x = -1
		elif target.global_position.x > global_position.x:
			_sprite2d.scale.x = 1


func animationVariableCheck():
	if velocity.is_zero_approx():
		is_running = false
	else:
		is_running = true

func _process(_delta:float):
	#flipSpriteCheck()
	pass

func _physics_process(_delta: float) -> void:
	animationVariableCheck()
	flipSpriteCheck()

func begin_attack_animation():
	is_attacking = true

func end_attack_animation():
	is_attacking = false

func SetTeamPrefix(prefix: String):
	self.teamPrefix = prefix


func _on_death():
	var tomb = tombStone.instantiate()
	tomb.position = self.position
	get_parent().add_child(tomb)
	
	super()


func onHpChange(newValue: int):
	hp_bar.value = newValue
	

func active_hitbox():
	var target = bt_player.blackboard.get_var("current_target")
	melee_attack_component.apply_damage(target)
