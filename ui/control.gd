# DropArea.gd
extends Control

# 定义一个信号，用于通知主游戏逻辑卡牌已被放置
signal card_placed(card_data)

# 用于存储父级 SidebarContainer 的 is_expanded 状态，
# 确保在侧边栏收起时不能放置卡牌
var can_drop_callback = true 

# 默认颜色
const BASE_MODULATE = Color(1.0, 1.0, 1.0, 1.0)
# 悬停颜色（视觉反馈）
const HOVER_MODULATE = Color(1.0, 1.0, 1.0, 0.5)

func _ready():
	modulate = BASE_MODULATE

# 1. 重写 _can_drop_data: 检查拖拽的数据是否可接受
func _can_drop_data(position, data):
	#print("can drop?")
	# 检查侧边栏是否展开
	return true

# 2. 重写 _drop_data: 拖拽物放下时调用
func _drop_data(position, data):
	print("dropping")
	# 恢复颜色
	modulate = BASE_MODULATE
	
	# 处理卡牌数据，添加到侧边栏的逻辑在这里
	print("Received card data: ", data)
	
	# 触发信号通知游戏逻辑
	emit_signal("card_placed", data)
	

	# 找到原始卡牌节点并移除它（重要！）
	# 假设 data["source_path"] 存储了卡牌的完整路径
	if data.has("source_path"):
		var card_node = get_node_or_null(data.source_path)
		print(card_node)
		add_child(card_node.duplicate())
		if is_instance_valid(card_node):
			# 发送信号通知 HandDeck 移除卡牌节点
			card_node.card_removed.emit(card_node)
			
	return true # 放置成功

# 3. 重写 _on_drag_data_exited: 当拖拽物离开区域时，恢复颜色
func _on_drag_data_exited():
	modulate = BASE_MODULATE
