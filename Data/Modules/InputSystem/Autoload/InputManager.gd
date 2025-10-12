extends Node
# InputManager.gd

signal keybinding_changed(action_name, new_key)

const CONFIG_FILE = "user://input_config.cfg"

# Definiciones automáticas de controles por defecto
const DEFAULT_BINDINGS = {
	"left_move_left": KEY_A,
	"left_move_right": KEY_D,
	"left_move_up": KEY_W,
	"right_move_left": KEY_LEFT,
	"right_move_right": KEY_RIGHT,
	"right_move_up": KEY_UP,
	"reset": KEY_SPACE,
	"Esc": KEY_ESCAPE,

}

func _ready():
	create_default_actions()
	load_input_config()

# Crea automáticamente todas las acciones con sus bindings por defecto
func create_default_actions():
	for action_name in DEFAULT_BINDINGS:
		# Crear la acción si no existe
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
		
		# Limpiar eventos existentes (solo si estamos creando por defecto)
		if not config_file_exists():
			InputMap.action_erase_events(action_name)
			
			# Agregar todos los controles por defecto para esta acción
	
			var event = InputEventKey.new()
			event.keycode = DEFAULT_BINDINGS[action_name]
			InputMap.action_add_event(action_name, event)

# Verifica si existe archivo de configuración
func config_file_exists() -> bool:
	return FileAccess.file_exists(CONFIG_FILE)

# Rebindear una acción (cambiar tecla)
func rebind_action(action_name: String, new_key : Key, remove_existing: bool = true) -> void:
	
	if not InputMap.has_action(action_name):
		push_warning("La acción '%s' no existe." % action_name)
		return
	
	if remove_existing:
		InputMap.action_erase_events(action_name)
	
	var new_event = InputEventKey.new()
	new_event.keycode = new_key
	InputMap.action_add_event(action_name, new_event)
	
	keybinding_changed.emit(action_name, new_key)
	save_input_config()


# Guardar configuración actual
func save_input_config() -> void:
	var config = ConfigFile.new()
	
	for action in InputMap.get_actions():
		if action.begins_with("ui_"):  # Ignorar acciones UI por defecto
			continue
		
		var keycodes = []
		var events = InputMap.action_get_events(action)
		for event in events:
			if event is InputEventKey:
				keycodes.append(event.keycode)
		
		if keycodes.size() > 0:
			config.set_value("input", action, keycodes)
	
	if config.save(CONFIG_FILE) != OK:
		push_error("Error guardando configuración de input")

# Cargar configuración guardada
func load_input_config() -> void:
	if not config_file_exists():
		return
	
	var config = ConfigFile.new()
	if config.load(CONFIG_FILE) != OK:
		return
	
	for action in config.get_section_keys("input"):
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		
		InputMap.action_erase_events(action)
		
		var keycodes = config.get_value("input", action)
		for keycode in keycodes:
			var event = InputEventKey.new()
			event.keycode = keycode
			InputMap.action_add_event(action, event)

# Resetear todos los controles a los valores por defecto
func reset_to_defaults() -> void:
	# Eliminar archivo de configuración
	if config_file_exists():
		var dir = DirAccess.open("user://")
		dir.remove(CONFIG_FILE)
	
	# Recrear todas las acciones
	for action_name in DEFAULT_BINDINGS:
		if InputMap.has_action(action_name):
			InputMap.action_erase_events(action_name)
		else:
			InputMap.add_action(action_name)
		
		for keycode in DEFAULT_BINDINGS[action_name]:
			var event = InputEventKey.new()
			event.keycode = keycode
			InputMap.action_add_event(action_name, event)

# Obtener nombre legible de una tecla
func get_key_name(keycode: int) -> String:
	return OS.get_keycode_string(keycode)
# Obtener Tecla legible de una letra

func get_key_number(keycode: String) -> int:
	return OS.find_keycode_from_string(keycode)

# Obtener la tecla primaria de una acción
func get_primary_key(action_name: String) -> int:
	
	if not InputMap.has_action(action_name):
		return KEY_NONE
	
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey:
			return event.keycode
	
	return KEY_NONE
	
# Obtener todas las teclas de una acción
func get_action_keys(action_name: String) -> Array:
	
	var keys = []
	if InputMap.has_action(action_name):
		var events = InputMap.action_get_events(action_name)
		for event in events:
			if event is InputEventKey:
				keys.append(event.keycode)
	return keys
	
# Verificar si una tecla ya está en uso
func is_key_used(keycode: int, exclude_action: String = "") -> bool:
	for action in InputMap.get_actions():
		if action.begins_with("ui_") or action == exclude_action:
			continue
		
		var events = InputMap.action_get_events(action)
		for event in events:
			if event is InputEventKey and event.keycode == keycode:
				
				return true
	
	return false
	
	
