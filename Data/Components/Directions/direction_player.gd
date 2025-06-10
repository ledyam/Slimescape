extends Resource

class_name PlayerDirections

var none : PlayerDirection = PlayerDirection.new()
var right : PlayerDirection = PlayerDirection.new()
var left : PlayerDirection = PlayerDirection.new()
var up : PlayerDirection = PlayerDirection.new()


func _init() -> void:
	none.setup('none', Vector2(0,0), 90)
	right.setup('right', Vector2(1,0), 0)
	left.setup('left', Vector2(-1,0), 180)


	
