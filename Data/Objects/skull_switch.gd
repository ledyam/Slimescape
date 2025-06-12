extends Sprite2D

@export_enum("RED","BLUE") var color : int 
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D: 
		CentralSignal.open_door.emit(color)
		queue_free()
