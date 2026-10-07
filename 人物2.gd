extends CharacterBody2D

# ========== 跨关卡保留血量（静态变量，所有场景共享） ==========
static var saved_health: int = 3

# ========== 信号 ==========
signal health_changed(new_health: int)
signal game_over()

# ========== 移动 / 二段跳 / 冲刺参数 ==========
@export var move_speed: float = 320.0
@export var jump_force: float = 520.0
@export var gravity: float = 1800.0
@export var dash_speed: float = 650.0
@export var dash_duration: float = 0.12
@export var dash_cooldown: float = 0.6
@export var max_jump_count: int = 2
var jump_count: int = 0

var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cd_timer: float = 0.0
var dash_dir: Vector2 = Vector2.RIGHT

# ========== 血量与受伤无敌帧 ==========
@export var max_health: int = 3
var health: int = 3
@export var hurt_cooldown: float = 0.8
var hurt_cd_timer: float = 0.0

func _ready():
	var spawn = get_parent().get_node_or_null("SpawnPoint")
	if spawn:
		global_position = spawn.global_position
	# 从静态变量读取上一关结束时的血量，没有就用满血
	health = saved_health
	emit_signal("health_changed", health)

func _physics_process(delta: float) -> void:
	# 受伤无敌帧倒计时
	if hurt_cd_timer > 0:
		hurt_cd_timer -= delta

	# 冲刺冷却
	if dash_cd_timer > 0:
		dash_cd_timer -= delta

	# 落地重置跳跃次数
	if is_on_floor():
		jump_count = 0

	if is_dashing:
		dash_timer -= delta
		velocity = dash_dir * dash_speed
		if dash_timer <= 0:
			is_dashing = false
	else:
		# 重力
		velocity.y += gravity * delta
		var input_dir: float = Input.get_axis("move_left", "move_right")
		velocity.x = input_dir * move_speed

		# 二段跳
		if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
			velocity.y = -jump_force
			jump_count += 1

		# 冲刺
		if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0:
			is_dashing = true
			dash_timer = dash_duration
			dash_cd_timer = dash_cooldown
			dash_dir = Vector2.RIGHT if input_dir >= 0 else Vector2.LEFT

	move_and_slide()

# 受伤函数，障碍物调用
func take_damage():
	# 无敌中 / 已经死亡，不扣血
	if hurt_cd_timer > 0 or health <= 0:
		return
	health -= 1
	saved_health = health  # 同步保存到静态变量
	hurt_cd_timer = hurt_cooldown
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("game_over")

func _process(delta: float) -> void:
	# 人物翻转
	var input_dir: float = Input.get_axis("move_left", "move_right")
	if not is_dashing and input_dir != 0:
		$Sprite2D.flip_h = input_dir < 0

	# 受伤无敌帧闪烁
	if hurt_cd_timer > 0:
		$Sprite2D.modulate.a = 0.5 + sin(Time.get_ticks_msec() / 50.0) * 0.4
	else:
		$Sprite2D.modulate.a = 1.0
