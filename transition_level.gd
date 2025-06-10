extends Control


func _ready() -> void:
	ControlUi.hide()
	%CurrentLevel.text = str(ControlUi.current_level)
	var tween = get_tree().create_tween()
	tween.tween_property(%CurrentLevel,"position",Vector2(20,20),2).set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	ControlUi.restart_timer()
	ControlUi.show()
	get_tree().change_scene_to_file("res://Data/Levels/level_%d.tscn"%((ControlUi.current_level)+1))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
