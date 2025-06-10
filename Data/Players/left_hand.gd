extends MainCharacter

@onready var anim_movement: AnimationPlayer = $AnimationPlayer

var movement_left : Dictionary = {
	_jump = "W",
	_izq= "A",
	_der = "D"
}
