extends Area2D

func _on_body_entered(body: Node2D):
	if body.has_method("take_damage"):
		body.take_damage()

func _ready():
	body_entered.connect(_on_body_entered)
