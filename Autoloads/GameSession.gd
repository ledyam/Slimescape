extends Node
class_name GameSessionClass

signal attempt_change(new_attempts)

var attempts: int = 0
var is_game_on : bool = false 
var is_dialogue_on : bool = false 
var is_tutorial_finished : bool = false 

func is_pausable_moment() -> bool : 
	return is_game_on and !is_dialogue_on

func GAME_ON () ->void : 
	is_game_on = true
	
### --- INTENTOS ---
func reset_attempts() -> void:
	attempts = 0
	
func add_attempt() -> void:
	attempts += 1
	attempt_change.emit(attempts)
func get_attempts() -> int:
	return attempts

#### --- GUARDADO / CARGADO ---
#
#func save_session() -> void:
	#var data = {
		#"attempts": attempts
	#}
	#var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	#if file:
		#file.store_string(to_json(data))
#
#func load_session() -> void:
	#if not FileAccess.file_exists(SAVE_PATH):
		#return
#
	#var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	#if file:
		#var content = file.get_as_text()
		#var data = {}
		#if content:
			#data = JSON.parse_string(content)
		#attempts = int(data.get("attempts", 0))
