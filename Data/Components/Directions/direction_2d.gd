extends Resource

class_name Direction2D

@export var _name : String
@export var  _vector_2d : Vector2
@export var _angle : float = 0 


func setup (name :String , vector_direction :Vector2 , angle : float = 0 ):
	_name = name 
	_vector_2d = vector_direction
	_angle = angle 
	pass
