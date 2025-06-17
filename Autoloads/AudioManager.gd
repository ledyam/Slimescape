##Controlador General de Audio 
##v1.0.1
extends Node
class_name AudioManagerClass



# Diccionario opcional para establecer nombres estándar de buses
const BUS = {
	MASTER = "Master",
	MUSIC = "Music",
	SFX = "SFX",
}
const INIT_VALUE : float = 0.6
func _ready():
	# Verifica si todos los buses requeridos existen
	for name in BUS.values():
		if not bus_exists(name):
			push_warning("Audio bus '%s' no existe." % name)
		else : set_volume(name,INIT_VALUE)
			

# Verifica si existe un bus por nombre
func bus_exists(bus_name: String) -> bool:
	return AudioServer.get_bus_index(bus_name) != -1

# Cambia el volumen de un bus (volumen en dB, típicamente entre -80.0 y 0.0)
func set_volume(bus_name: String, volume_db: float) -> void:
	var index = AudioServer.get_bus_index(bus_name)
	if index != -1:
		AudioServer.set_bus_volume_db(index, clamp(volume_db, -80.0, 0.0))
	else:
		push_warning("No se pudo cambiar volumen: bus '%s' no encontrado." % bus_name)

# Obtiene el volumen actual de un bus
func get_volume(bus_name: String) -> float:
	var index = AudioServer.get_bus_index(bus_name)
	return AudioServer.get_bus_volume_db(index) if index != -1 else -80.0

# Silencia o activa un bus
func set_bus_mute(bus_name: String, mute: bool) -> void:
	var index = AudioServer.get_bus_index(bus_name)
	if index != -1:
		AudioServer.set_bus_mute(index, mute)
	else:
		push_warning("No se pudo silenciar: bus '%s' no encontrado." % bus_name)

# Devuelve si un bus está muteado
func is_bus_muted(bus_name: String) -> bool:
	var index = AudioServer.get_bus_index(bus_name)
	return AudioServer.is_bus_mute(index) if index != -1 else false

# Silencia todos los buses opcionalmente excepto algunos
func mute_all_buses(except_buses: Array = []) -> void:
	var count = AudioServer.get_bus_count()
	for i in range(count):
		var name = AudioServer.get_bus_name(i)
		if name in except_buses:
			continue
		AudioServer.set_bus_mute(i, true)

# Restaura sonido a todos los buses
func unmute_all_buses() -> void:
	var count = AudioServer.get_bus_count()
	for i in range(count):
		AudioServer.set_bus_mute(i, false)
