extends Node2D

@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	sprite_2d.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
