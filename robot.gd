extends Area2D

@export var move_range: float = 200.0    # 来回移动距离（像素）
@export var move_speed: float = 150.0    # 移动速度
@export var move_axis: Vector2 = Vector2.RIGHT  # 移动方向（左右用RIGHT，上下用DOWN）

var start_pos: Vector2
var t: float = 0.0
var direction: int = 1

func _ready():
	start_pos = global_position
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float):
	t += delta * move_speed / move_range
	# 正弦来回：在 start_pos 和 start_pos + move_axis*move_range 之间往返
	var offset = (0.5 + 0.5 * sin(t * PI)) * move_range
	global_position = start_pos + move_axis * offset

func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage()
