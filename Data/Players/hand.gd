extends CharacterBody2D

class_name MainCharacter

var direction = PlayerDirections.new()
var current_direction 

const SPEED = 190.0
const JUMP_VELOCITY = -350.0
var is_moving = false 
