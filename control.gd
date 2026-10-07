extends Control
@export var player:CharacterBody2D

func _ready():
	# Control 铺满全屏
	set_anchors_preset(Control.PRESET_FULL_RECT)

	# Label1：生命值，固定左上角
	$Label1.set_anchors_preset(Control.PRESET_TOP_LEFT)
	$Label1.position = Vector2(20, 20)
	$Label1.size = Vector2(400, 60)

	# 连接玩家信号
	if player == null:
		print("错误：Player 未绑定！")
		return
	player.health_changed.connect(update_health)
	player.game_over.connect(on_game_over)

func update_health(hp: int):
	$Label1.text = "生命值：%d" % hp

func on_game_over():
	# 血量归0后暂停游戏，按R重启
	get_tree().paused = true

func _process(delta):
	if get_tree().paused and Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		get_tree().reload_current_scene()
