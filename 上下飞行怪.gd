extends Area2D

@export var point_a:Vector2   # 上方起点
@export var point_b:Vector2   # 下方终点
@export var fly_speed:float = 120.0

var tween:Tween

func _ready():
	global_position = point_a
	body_entered.connect(_on_body_entered)
	fly_down()

# 飞向下方B点
func fly_down():
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	var time = point_a.distance_to(point_b) / fly_speed
	tween.tween_property(self,"global_position",point_b,time)
	tween.finished.connect(fly_up)

# 飞回上方A点
func fly_up():
	if tween != null and tween.is_running():
		tween.kill()
	tween = create_tween()
	var time = point_b.distance_to(point_a) / fly_speed
	tween.tween_property(self,"global_position",point_a,time)
	tween.finished.connect(fly_down)

# 碰到玩家扣血
func _on_body_entered(body:Node2D):
	if body.has_method("take_damage"):
		body.take_damage()
