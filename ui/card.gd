# Card.gd
extends TextureRect

class_name Card
# 定义一个信号，用于通知手牌 Deck 脚本，卡牌已被成功放置并需要移除
signal card_removed(card_node)

# 假设的卡牌数据，您需要根据实际游戏逻辑填充
var card_data = {
	"type": "Action",
	"card_id": 101,
	"source_path": "" # 用于放置成功后，接收区可以知道要移除哪个卡牌
}

func _ready():
	# 启用鼠标事件接收
	mouse_filter = MOUSE_FILTER_PASS
	card_data.source_path = get_path() # 记录自己的路径
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	oldpos = global_position


# --- 核心拖拽方法 ---

# 1. 重写 _get_drag_data: 当用户开始拖拽时调用
func _get_drag_data(_position):
	print("drag begin")
	## 如果处于禁用状态，则不允许拖拽
	##if mouse_filter == MOUSE_FILTER_IGNORE:
		##return null
#
	## 创建一个用于跟随鼠标的预览节点
	##var drag_preview = TextureRect.new()
	##drag_preview.texture = texture
	### 调整预览尺寸
	##drag_preview.custom_minimum_size = size * 0.8
	##drag_preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE 
	#
	#return card_data
	# 1. 准备数据（传自己过去，方便接收者处理）
	var data = self
	
	# 2. 创建视觉替身 (Preview)
	# 我们可以直接复制一个 TextureRect
	var preview = Card.new()
	preview.texture = texture
	preview.material = material
	preview.expand_mode = expand_mode
	preview.size = size
	# 稍微旋转一点，增加“抓取感”
	#preview.rotation_degrees = 5 
	
	# 3. 设置 Preview 的属性
	# 这一步是为了让 Preview 不要居中于鼠标，而是对齐你点击的位置
	# 这样才像“直接抓取”
	preview.position = -_position 
	
	# 创建一个容器来承载 Preview（为了能应用偏移量）
	var c = Control.new()
	c.add_child(preview)
	
	# 设置拖拽预览，并强制不透明（默认是半透明的）
	set_drag_preview(c) 
	
	# 4. 【核心魔法】把自己藏起来！
	# 看起来就像是你把自己从槽位里拿走了
	self.modulate.a = 0.0 
	
	return card_data

func _can_drop_data(at_position, data):
	# 这里定义谁能放回来，通常这里写 false，除非支持交换
	return false

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		# 拖拽结束了（无论有没有成功放下）
		# 如果没有成功放下（is_drag_successful() == false），我们需要把自己显示回来
		# 如果成功放下了，通常接收者会把我们移动过去，或者删除我们
		if not is_drag_successful():
			var tween = create_tween()
			tween.tween_property(self, "modulate:a", 1.0, 0.2)
		else:
			# 如果成功了，接收方通常会处理我的父节点变更
			# 但如果只是数据传递，这里也应该恢复显示
			self.modulate.a = 1.0

var TIME = 0
var oldpos = Vector2(0,0)

var is_hovering: bool = false


func _input(event: InputEvent) -> void:
	if not is_dragging:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			mouse_filter = Control.MOUSE_FILTER_PASS
			is_dragging = false
	#elif event is InputEventMouseMotion:
		#global_position = get_global_mouse_position() + drag_offset

var drag_offset = Vector2.ZERO
var is_dragging = false

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_dragging = true
				mouse_filter = Control.MOUSE_FILTER_IGNORE
				drag_offset = global_position - get_global_mouse_position()
				set_instance_shader_parameter("x_rot", 0)
				set_instance_shader_parameter("y_rot", 0)
				

func _on_mouse_entered():
	is_hovering = true
	set_instance_shader_parameter("hovering", is_hovering)

func _on_mouse_exited():
	is_hovering = false
	set_instance_shader_parameter("hovering", is_hovering)
	_Tween_X_To_Base()
	_Tween_Y_To_Base()


func _Update_X(value: float):
	set_instance_shader_parameter("x_rot", value)

func _Update_Y(value: float):
	set_instance_shader_parameter("y_rot", value)

func _Tween_X_To_Base():
	var tween = create_tween()
	tween.tween_method(Callable(self, "_Update_X"), get_instance_shader_parameter("x_rot"), 0.0, 0.1) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)


func _Tween_Y_To_Base():
	var tween = create_tween()
	tween.tween_method(Callable(self, "_Update_Y"), get_instance_shader_parameter("y_rot"), 0.0, 0.1) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)


func _process(delta: float) -> void:
	TIME += delta
	if is_dragging:
		var velo = (global_position - oldpos).x * 0.05
		oldpos = global_position
		self.rotation = clamp(lerp(self.rotation, velo, 0.5),-0.3,0.3)
		self.scale = lerp(self.scale,Vector2(1.05,1.05),0.25)
	else:
		self.rotation = sin(TIME)*(0.035)
		self.position.x += cos(TIME)*(0.1)
		self.position.y += sin(TIME-90)*(0.1)
	if is_hovering and not is_dragging:
		self.scale = lerp(self.scale,Vector2(1.05,1.05),0.25)
		
		var l_mouse_pos = get_local_mouse_position()
		var mouse_rot = Vector2(
			20 * (l_mouse_pos.x - size.x/2) / size.x,
			20 * (l_mouse_pos.y - size.y/2) / size.y
		)
		set_instance_shader_parameter("x_rot", -mouse_rot.y)
		set_instance_shader_parameter("y_rot", mouse_rot.x)
	else:
		self.scale = lerp(self.scale,Vector2(1,1),0.25)
