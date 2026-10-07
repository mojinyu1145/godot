extends Area2D

# 在检查器填写两个点的坐标
@export var point_a:Vector2   # 左边起点
@export var point_b:Vector2   # 右边终点
@export var fly_speed:float = 130.0

var tween:Tween

func _ready():
	print("point_a的值：", point_a)
	global_position = point_a
	body_entered.connect(_on_body_entered)
	fly_to_b()

# 飞向右边B点
func fly_to_b():
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	var time = point_a.distance_to(point_b) / fly_speed
	tween.tween_property(self,"global_position",point_b,time)
	tween.finished.connect(fly_to_a)

# 飞回左边A点
func fly_to_a():
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	var time = point_b.distance_to(point_a) / fly_speed
	tween.tween_property(self,"global_position",point_a,time)
	tween.finished.connect(fly_to_b)

# 碰到玩家扣血
func _on_body_entered(body:Node2D):
	if body.has_method("take_damage"):
		body.take_damage()
