extends MainCharacter
@onready var anim_movement: AnimationPlayer = $AnimationPlayer


var movement : Dictionary = {
	_jump = "ui_up",
	_izq =  "ui_left",
	_der = "ui_right"
}
