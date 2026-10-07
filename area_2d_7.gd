extends Area2D

@export var next_level_path: String = "res://场景2.tscn"  # 第二关场景路径
@export var fade_out_time: float = 0.5

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		# 可选：淡出后切场景
		var tween = create_tween()
		tween.tween_interval(fade_out_time)
		tween.tween_callback(change_to_next_level)

func change_to_next_level():
	get_tree().paused = false  # 防止上一关暂停着
	get_tree().change_scene_to_file(next_level_path)
