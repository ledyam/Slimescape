extends MainCharacter

@onready var anim_movement: AnimationPlayer = $AnimationPlayer

var movement_left : Dictionary = {
	_jump = "W",
	_izq= "A",
	_der = "D"
}


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "RightHand":
		CentralSignal.increment_level.emit()
	pass # Replace with function body.
