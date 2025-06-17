# LevelTimeManager.gd
extends Node

signal level_time_started(max_time)
signal level_time_changed(time_left , max_level_time)
signal level_time_ended
signal level_time_reset

var current_time: float = 0.0
var max_level_time: float = 60.0
var is_running: bool = false

func _ready() -> void:
	CentralSignal.connect("player_is_movement" , on_player_movement)
	
	
func on_player_movement():
	if LevelManager.current_level_index != 0 :
		start_level_time(LevelManager.get_time_level())
	
	
func start_level_time(duration: float):
	max_level_time = duration
	current_time = duration
	is_running = true
	emit_signal("level_time_started", max_level_time)

func _process(delta):
	if not is_running or get_tree().paused:
		return
	
	current_time -= delta
	current_time = max(0.0, current_time)
	emit_signal("level_time_changed", current_time , max_level_time)
	
	if current_time <= 0.0:
		is_running = false
		emit_signal("level_time_ended")

func pause_time():
	is_running = false

func resume_time():
	if current_time > 0.0:
		is_running = true

func add_time(seconds: float):
	current_time = min(current_time + seconds, max_level_time)

func reset_level_timer():
	is_running = false
	emit_signal("level_time_reset")
	
