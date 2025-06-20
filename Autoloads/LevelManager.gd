extends Node

signal level_changed(current_level_index ) 


var current_level_index := 0
var transition_packed_scene : PackedScene = preload("res://UI/Level Transition/transition_level.tscn")

var level_paths := [
	"res://Data/Levels/level_tutorial.tscn",
	"res://Data/Levels/level_1.tscn",
	"res://Data/Levels/level_2.tscn",
	"res://Data/Levels/level_3.tscn",
	"res://Data/Levels/level_4.tscn",
	"res://Data/Levels/level_5.tscn",
	"res://Data/Levels/level_6.tscn",
	"res://Data/Levels/level_7.tscn",
	"res://Data/Levels/level_8.tscn",
	"res://Data/Levels/level_9.tscn"
]
var level_time :={
	0 : 12,
	1 : 12,
	2 : 12,
	3 : 12,
	4 : 12,
	5 : 12,
	6 : 12,
	7 : 12,
	8 : 12,
	9 : 12,

}

var next_level_path : String = ""

func _ready() -> void:
	LevelTimeManager.connect("level_time_ended",restart_level)
	
func go_to_next_level():
	current_level_index += 1
	level_changed.emit(current_level_index)
	if current_level_index >= level_paths.size():
		print("¡Juego completado!")
		return
	next_level_path = level_paths[current_level_index]
	get_tree().change_scene_to_file(level_paths[current_level_index])

func restart_level():
	get_tree().change_scene_to_file(level_paths[current_level_index])
	
func _get_to_transition():
	LevelTimeManager.reset_level_timer()
	get_tree().change_scene_to_packed(transition_packed_scene)

func get_time_level():
	return level_time[current_level_index]
