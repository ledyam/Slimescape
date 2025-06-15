extends CanvasLayer

var wips: int = 0
var current_level: int = 0 
var RESTANT_TIMER = 8 # Tasa a la que el valor del ProgressBar disminuye por segundo
const FINAL_TIME = 0
var exist_movement_hand: bool = false
var can_reset: bool = true
var is_resetting: bool = false
@onready var canvas_layer: CanvasLayer = $UIContainer/CanvasLayer



# Nodos para efectos visuales
@onready var transition_rect: ColorRect = $TransitionRect
@onready var ui_container: Control = $UIContainer 

# Referencia a tus nodos ProgressBar (asegúrate de que los nombres de los nodos coincidan)
@onready var main_time_bar: ProgressBar = %ProgressBar
@onready var secondary_time_bar: ProgressBar = %ProgressBar2

# Variables para almacenar el ShaderMaterial de cada ProgressBar
var main_bar_shader_material: ShaderMaterial = null
var secondary_bar_shader_material: ShaderMaterial = null


# Configuración de vibración
const SHAKE_DISTANCE: float = 3.0
const SHAKE_DURATION: float = 0.10
const SHAKE_REPEATS: int = 6
var NODOS_NO : Array = ["res://Data/MenuPrincipal/principal_menu.tscn","res://UI/transition_level.tscn"]
var original_ui_position: Vector2 = Vector2.ZERO




func _ready() -> void:
	CentralSignal.increment_level.connect(on_increment_level)
	CentralSignal.play_movement.connect(on_play_movement)
	CentralSignal.pause_movement.connect(on_pause_movement)
	$AnimationPlayer.play("default")
	
	# --- NUEVO: Obtener los ShaderMaterial de los ProgressBars ---
	if main_time_bar:
		# Asegúrate de que el material sea un ShaderMaterial antes de usarlo
		if main_time_bar.material is ShaderMaterial:
			main_bar_shader_material = main_time_bar.material
			main_time_bar.show_percentage = false # Deshabilita el texto de porcentaje por defecto
		else:
			push_warning("El material del ProgressBar principal no es un ShaderMaterial o no está asignado.")
	
	if secondary_time_bar:
		if secondary_time_bar.material is ShaderMaterial:
			secondary_bar_shader_material = secondary_time_bar.material
			secondary_time_bar.show_percentage = false # Deshabilita el texto de porcentaje por defecto
		else:
			push_warning("El material del ProgressBar secundario no es un ShaderMaterial o no está asignado.")
	# --- FIN NUEVO ---

	if ui_container:
		original_ui_position = ui_container.position
	
	await get_tree().process_frame
	restart_timer() # Esta función ahora también actualizará el shader

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and can_reset and not is_resetting:
		if get_tree().current_scene.scene_file_path not in NODOS_NO:
			reset_level()

func _process(delta: float) -> void:
	if exist_movement_hand and not is_resetting:
		# Actualiza los valores de los ProgressBars
		if main_time_bar:
			main_time_bar.value -= RESTANT_TIMER * delta
			# --- NUEVO: Actualizar el shader del ProgressBar principal ---
			_update_bar_shader(main_time_bar, main_bar_shader_material)
		
		if secondary_time_bar:
			secondary_time_bar.value -= RESTANT_TIMER * delta
			# --- NUEVO: Actualizar el shader del ProgressBar secundario ---
			_update_bar_shader(secondary_time_bar, secondary_bar_shader_material)

		# La lógica de reset sigue siendo la misma, basada en el valor del ProgressBar principal
		if main_time_bar and main_time_bar.value <= FINAL_TIME: 
			reset_level()
		   
func reset_level():
	if is_resetting:
		return
		
	is_resetting = true
	can_reset = false
	CentralSignal.pause_movement.emit()
	
	# Iniciar efectos de reinicio
	start_ui_shake()
	
	# Transición de fade
	transition_rect.visible = true
	var tween = create_tween().set_parallel(true)
	tween.tween_property(transition_rect, "color:a", 1, SHAKE_DURATION * SHAKE_REPEATS/2)
	tween.tween_callback(_perform_scene_reload)
	
func start_ui_shake():
	if not ui_container:
		return
	
	original_ui_position = ui_container.position
	var shake_tween = create_tween().set_loops(SHAKE_REPEATS)
	
	# Patrón de vibración: derecha-izquierda
	shake_tween.tween_property(ui_container, "position:x", 
		original_ui_position.x + SHAKE_DISTANCE, SHAKE_DURATION/2)
	shake_tween.tween_property(ui_container, "position:x", 
		original_ui_position.x - SHAKE_DISTANCE, SHAKE_DURATION/2)
	
	# Al finalizar, volver a posición original
	shake_tween.tween_callback(func():
		ui_container.position = original_ui_position
	)

func _perform_scene_reload():
	var current = get_tree().current_scene
	if current != null and current.scene_file_path != "":
		increment_wip()
		# --- Se mantiene el restart_timer aquí, que ahora también actualiza el shader ---
		restart_timer() 
		get_tree().change_scene_to_file(current.scene_file_path)
		
		# Esperar a que la nueva escena esté lista
		await get_tree().process_frame
		
		# Finalizar efectos
		var tween = create_tween().set_parallel(true)
		tween.tween_property(transition_rect, "color:a", 0.0, 0.3)
		tween.tween_callback(func(): 
			transition_rect.visible = false
			is_resetting = false
			can_reset = true
			# --- Opcional: Reactivar el pulso del shader si se deshabilitó al reiniciar ---
			# Esto asume que tienes 'enable_low_time_pulse' como un uniform en tu shader
			if main_bar_shader_material:
				main_bar_shader_material.set_shader_parameter("enable_low_time_pulse", true)
			if secondary_bar_shader_material:
				secondary_bar_shader_material.set_shader_parameter("enable_low_time_pulse", true)
		)
	else:
		printerr("Error: No se pudo recargar la escena")
		transition_rect.visible = false
		is_resetting = false
		can_reset = true


func on_pause_movement():
	exist_movement_hand = false
	
func on_play_movement():
	exist_movement_hand = true
	 
func on_increment_level() -> void: 
	current_level += 1
	%LevelLabel.text = str(current_level)

func restart_timer() -> void: 
	# Restablece los valores de los ProgressBars a su máximo
	if main_time_bar:
		main_time_bar.value = main_time_bar.max_value
		_update_bar_shader(main_time_bar, main_bar_shader_material) # Actualiza el shader
	
	if secondary_time_bar:
		secondary_time_bar.value = secondary_time_bar.max_value
		_update_bar_shader(secondary_time_bar, secondary_bar_shader_material) # Actualiza el shader

	# Reactiva _process para la cuenta atrás si se detuvo
	set_process(true)

func increment_wip() -> void:
	wips += 1
	%WipsLabel.text = str(wips)

# --- NUEVA FUNCIÓN: Para actualizar el shader de una barra específica ---
func _update_bar_shader(bar_node: ProgressBar, shader_mat: ShaderMaterial):
	if shader_mat == null: # Verifica si el ShaderMaterial fue cargado correctamente
		return

	# Calcula el progreso normalizado (entre 0.0 y 1.0)
	var normalized_progress = bar_node.value / bar_node.max_value
	
	# Envía el valor de 'progress' al shader
	shader_mat.set_shader_parameter("progress", normalized_progress)
