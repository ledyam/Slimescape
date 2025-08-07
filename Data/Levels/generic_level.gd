extends Node2D

const DURATION : float = 0.35 
const STRENGTH : float = 15.0

@onready var camera: Camera2D = $Camera2D 

func _ready() -> void:
	LevelManager.connect("level_restarting", _on_level_restarting)

func _on_level_restarting():
	shake_camera(DURATION, STRENGTH) 

func shake_camera(duration: float, strength: float):
	if not is_instance_valid(camera):
		print("La cámara de este nivel no es válida.")
		return
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	
	var shake_count = 10
	for i in range(shake_count):
		var rand_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * strength
		tween.tween_property(camera, "offset", rand_offset, duration / shake_count)
	
	tween.tween_property(camera, "offset", Vector2.ZERO, 0)
