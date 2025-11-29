extends Control

@onready var panel = $Panel
@onready var button: Button = $Panel/Button
#@onready var v_box_container: VBoxContainer = $Panel/VBoxContainer

var is_expanded = true

const EXPANDED_WIDTH = 0 # 展开时的宽度
const COLLAPSED_WIDTH = -200 # 收起时的宽度（只显示按钮）
const DURATION = 0.3 # 动画时长

func _ready():
	# 连接按钮信号
	button.pressed.connect(toggle_sidebar)

func toggle_sidebar():
	is_expanded = !is_expanded
	print(is_expanded)
	var target_width = EXPANDED_WIDTH if is_expanded else COLLAPSED_WIDTH
	var tween = get_tree().create_tween()
	# 使用 Tween 平滑改变宽度
	
	tween.tween_property(self, "global_position:x", target_width, DURATION)

# 您可能需要调整 rect_position 以确保它从左侧滑出/入
# 例如，如果锚点在左上角，可以只调整宽度。
# 1. 重写 _can_drop_data: 检查数据是否可接受
#func _can_drop_data(position, data):
	## 只有当侧边栏展开时才允许放置
	## 您可能需要通过信号或 get_node() 检查父级 SidebarContainer 的状态
	#var sidebar_container = get_parent().get_parent() # 假设 DropArea 的父级结构
	#if !sidebar_container.is_expanded:
		#return false
		#
	## 检查 data 是否包含预期的卡牌类型信息
	#if typeof(data) == TYPE_DICTIONARY and "id" in data:
		## 视觉反馈：当拖拽物进入时，改变 DropArea 的颜色
		#modulate = Color(1.0, 1.0, 1.0, 0.5) # 例如，变亮
		#return true
		#
	#return false
#
## 2. 重写 _drop_data: 拖拽物放下时调用
#func _drop_data(position, data):
	## 处理卡牌数据（data），例如将其添加到侧边栏的列表中
	#print("Received card data: ", data)
	#
	## 触发信号通知主游戏逻辑卡牌已被放置
	#emit_signal("card_dropped", data)
	#
	## 恢复 DropArea 的视觉状态
	#modulate = Color(1.0, 1.0, 1.0, 1.0)
	#
	## 注意：原始卡牌节点 (Card.gd) 仍然是隐藏状态。
	## 游戏逻辑需要在卡牌被放置后，销毁/移除原始卡牌，或将其重新添加到 deck 中。
#
## 3. _gui_input (可选): 处理拖拽离开时的视觉恢复
#func _gui_input(event):
	#if event is InputEventMouseMotion and event.is_pressed():
		## 如果正在拖拽，并且鼠标移出区域，恢复颜色
		##if is_drag_data_accepted(): # 这是一个伪函数，你需要自己实现追踪逻辑
		#modulate = Color(1.0, 1.0, 1.0, 1.0)
