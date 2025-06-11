extends Node2D

@export var record : Vector2
func _ready():
	$AnimatedSprite2D.play("default")
	var tween = get_tree().create_tween()
	tween.tween_property(self , "global_position",self.global_position+record,4).set_trans(Tween.TRANS_LINEAR).set_delay(2)
	tween.tween_property(self , "global_position",self.global_position-record,4).set_trans(Tween.TRANS_LINEAR).set_delay(2)
	tween.set_parallel(false)
	tween.set_loops()
	
