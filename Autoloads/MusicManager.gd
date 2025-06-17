extends Node
class_name MusicManagerClass

## Volumen por defecto de la música (en dB)
const DEFAULT_VOLUME: float = -10.0
var AUDIO_BUS : String = "Music"
@onready var audio_player: AudioStreamPlayer = AudioStreamPlayer.new()
var current_music_path: String = ""


func _ready() -> void:
	# Configuración inicial del reproductor
	add_child(audio_player)
	audio_player.bus = AUDIO_BUS
	audio_player.volume_db = DEFAULT_VOLUME
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS  # Funciona incluso en pausa
## Reproduce una música en loop
func play_music(music_path: String, fade_duration: float = 0.0) -> void:
	if current_music_path == music_path and audio_player.playing:
		return  # Ya está sonando esta música
	
	current_music_path = music_path
	
	var music: AudioStream = load(music_path)
	if not music:
		push_error("No se pudo cargar la música: ", music_path)
		return
	
	music.loop = true
	
	if fade_duration > 0 and audio_player.playing:
		# Fade out de la música actual
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -80.0, fade_duration)
		tween.tween_callback(func(): 
			_change_music(music)
			fade_in(fade_duration)
		)
	else:
		_change_music(music)

## Cambia la música inmediatamente (sin fade)
func _change_music(new_music: AudioStream) -> void:
	audio_player.stream = new_music
	audio_player.play()

## Detiene la música
func stop_music(fade_duration: float = 0.0) -> void:
	if fade_duration > 0:
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -80.0, fade_duration)
		tween.tween_callback(audio_player.stop)
	else:
		audio_player.stop()

## Aplica fade in a la música actual
func fade_in(duration: float) -> void:
	var original_volume = audio_player.volume_db
	audio_player.volume_db = -80.0
	var tween = create_tween()
	tween.tween_property(audio_player, "volume_db", original_volume, duration)

## Ajusta el volumen
func set_volume(db: float) -> void:
	audio_player.volume_db = db

## Pausa/reanuda la música
func set_paused(paused: bool) -> void:
	audio_player.stream_paused = paused


func is_paused() -> bool : 
	return audio_player.stream_paused
