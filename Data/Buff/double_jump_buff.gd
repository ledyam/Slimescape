extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter: 
		CentralSignal.double_jump.emit(body.ID)
		queue_free()
	pass # Replace with function body.
