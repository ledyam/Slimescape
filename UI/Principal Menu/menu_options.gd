extends Control

@onready var screen_mode_button := %ScreenModeButton
@onready var screen_mode_menu :PopupMenu = screen_mode_button.get_menu_popup(0)

# Mapeo de ID -> texto -> modo
var screen_modes = {
	0: {"text": "Ventana", "mode": DisplayServer.WINDOW_MODE_WINDOWED},
	1: {"text": "Pantalla Completa", "mode": DisplayServer.WINDOW_MODE_FULLSCREEN},
	2: {"text": "Sin Bordes", "mode": DisplayServer.WINDOW_MODE_MAXIMIZED},
	3: {"text": "Exclusiva", "mode": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN}
}

func _ready():


	# Conectar señal de selección
	screen_mode_menu.connect("id_pressed", Callable(self, "_on_screen_mode_selected"))

	# Establecer texto inicial del botón según modo actual
	var current_mode = DisplayServer.window_get_mode()
	for entry in screen_modes:
		if screen_modes[entry]["mode"] == current_mode:
			screen_mode_menu.title = screen_modes[entry]["text"]
			break

func _on_screen_mode_selected(id: int) -> void:
	var mode_data = screen_modes.get(id)
	if mode_data:
		DisplayServer.window_set_mode(mode_data["mode"])
		screen_mode_menu.title = mode_data["text"]  # ← Aquí cambia el texto del botón




func _on_sound_h_slider_value_changed(value: float) -> void:
	if AudioManager.bus_exists("SFX"):
		AudioManager.set_volume("SFX",value)


func _on_music_slider_value_changed(value: float) -> void:
	if AudioManager.bus_exists("Music"):
		AudioManager.set_volume("Music",value)
