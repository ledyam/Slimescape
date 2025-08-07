extends Node2D

@export var buff_type : Buff


func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$Sound/Buff.stream = buff_type.sound

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is MainCharacter: 
		CentralSignal.active_buff.emit(body.ID , buff_type.type)
		queue_free()
	pass # Replace with function body.
