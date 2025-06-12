extends CharacterBody2D

class_name MainCharacter

const SPEED = 140.0
const JUMP_VELOCITY = -350.0
var leaved_floor : bool = false 
var is_jumping : bool = false
var has_started : bool = false  
var double_jump : bool = false 


func started_timer():
	CentralSignal.play_movement.emit()


func _ready() -> void:
	CentralSignal.double_jump.connect(on_double_jump)
	

func on_double_jump():
	double_jump = true
	pass
