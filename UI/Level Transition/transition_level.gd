extends Control

@onready var current_level_label: Label = %CurrentLevel

# Configuración de animación
const MOVE_DISTANCE: float = 50.0
const ANIM_DURATION: float = 0.75

func _ready() -> void:
	ControlUi.canvas_layer.hide()
	ControlUi.hide()
	current_level_label.text = str(ControlUi.current_level)
	$"Sound/Clock-tick-tik-tak-76043".play()
	# Animación de transición
	animate_level_change()

func animate_level_change():
	var tween = create_tween().set_parallel(true)
	
	# 1. Animación de salida (número actual cae y se desvanece)
	tween.tween_property(current_level_label, "position:y", 
						current_level_label.position.y + MOVE_DISTANCE, 
						ANIM_DURATION).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(current_level_label, "modulate:a", 
						0, ANIM_DURATION)
	
	await tween.finished
	
	# 2. Cambiar texto y resetear propiedades
	current_level_label.text = str(ControlUi.current_level + 1)
	current_level_label.position.y -= MOVE_DISTANCE
	
	# 3. Animación de entrada (nuevo número aparece desde arriba)
	current_level_label.position.y = current_level_label.position.y - 50
	tween = create_tween().set_parallel(true)
	tween.tween_property(current_level_label, "position:y", 
						current_level_label.position.y + MOVE_DISTANCE, 
						ANIM_DURATION).set_trans(Tween.TRANS_BACK)
	tween.tween_property(current_level_label, "modulate:a", 
						1, ANIM_DURATION)
	
	# 4. Efecto de brillo final
	await tween.finished
	tween = create_tween()
	tween.tween_property(current_level_label, "modulate", 
						Color(1.5, 1.5, 1.5, 1), 0.15)
	tween.tween_property(current_level_label, "modulate", 
						Color.WHITE, 0.25)
	
	await tween.finished
	transition_to_next_level()

func transition_to_next_level():
	# Preparar siguiente nivel
	CentralSignal.pause_movement.emit()
	ControlUi.restart_timer()
	ControlUi.show()
	ControlUi.canvas_layer.show()
	# Fade out suave antes de cargar
	var exit_tween = create_tween()
	exit_tween.tween_property(self, "modulate:a", 0, 0.3)
	await exit_tween.finished
	
	# Cargar escena del siguiente nivel
	get_tree().change_scene_to_file("res://Data/Levels/test_level.tscn")
	#get_tree().change_scene_to_file("res://Data/Levels/level_%d.tscn" % (ControlUi.current_level + 1))
