

extends CanvasLayer

# Señal para notificar a LevelManager que la animación de transición ha terminado.
signal transition_finished

# --- Referencias a los Nodos del HUD ---

@onready var transition_rect: ColorRect = $TransitionRect
@onready var attempt_label: Label = %AttemptLabel
@onready var hud_container: Control = $HUDContanier # Referencia para el fade out

var _transition_material: ShaderMaterial

func _ready() -> void:
	
	LevelManager.connect("level_changed", on_level_changed)
	GameSession.connect("attempt_change", on_attempt_change)
	LevelManager.connect("level_restarting", play_restart_transition)

	if transition_rect.material is ShaderMaterial:
		_transition_material = transition_rect.material
	
	_reset_all_states()
	
	hide()

func on_level_changed(current_level: int):
	%CurrentLevelLabel.text = str(current_level)

func on_attempt_change(current_attempts: int):
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(attempt_label, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(attempt_label, "scale", Vector2(1.0, 1.0), 0.4)
	attempt_label.text = str(current_attempts)


# --- FUNCIÓN PRINCIPAL DE TRANSICIÓN: Glitch global + Fade Out sutil del HUD ---
func play_restart_transition():
	var duration = 0.35
	var tween = create_tween().set_parallel(true)
	
	# --- NUEVA ANIMACIÓN DEL HUD: Un simple y sutil Fade Out ---
	# El contenedor del HUD simplemente se desvanece. Es rápido y limpio.
	tween.tween_property(hud_container, "modulate:a", 0.0, duration * 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# -----------------------------------------------
	# SECCIÓN DE ANIMACIÓN DEL SHADER 
	# -----------------------------------------------
	# El efecto de glitch de pantalla sigue funcionando al mismo tiempo.
	tween.tween_property(_transition_material, "shader_parameter/glitch_intensity", 0.1, duration * 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(_transition_material, "shader_parameter/vignette_opacity", 1.0, duration * 0.7).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_transition_material, "shader_parameter/vignette_intensity", 0.0, duration * 0.7).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(_transition_material, "shader_parameter/fade_to_black", 1.0, duration * 0.4).set_delay(duration * 0.6)

	tween.finished.connect(func():
		_reset_all_states()
		transition_finished.emit()
	)

# Función de utilidad para limpiar y resetear el estado de la transición.
func _reset_all_states():
	# Resetea el shader.
	if is_instance_valid(_transition_material):
		_transition_material.set_shader_parameter("glitch_intensity", 0.0)
		_transition_material.set_shader_parameter("vignette_opacity", 0.0)
		_transition_material.set_shader_parameter("vignette_intensity", 0.8)
		_transition_material.set_shader_parameter("fade_to_black", 0.0)
		
	# Resetea el HUD a un estado visible y opaco.
	if is_instance_valid(hud_container):
		hud_container.modulate = Color(1, 1, 1, 1)
