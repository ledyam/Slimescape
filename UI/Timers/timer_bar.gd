extends HBoxContainer

@onready var progress_time_bar: ProgressBar = $ProgressTimeBar
@onready var progress_time_bar_2: ProgressBar = $ProgressTimeBar2


func _ready():
	LevelTimeManager.level_time_started.connect(_on_time_started)
	LevelTimeManager.level_time_changed.connect(_on_time_changed)
	LevelTimeManager.level_time_ended.connect(_on_time_ended)
	LevelTimeManager.level_time_reset.connect(_on_time_ended)
	
func _on_time_started(max_time: float):
	progress_time_bar.max_value = max_time
	progress_time_bar.value = max_time
	progress_time_bar_2.max_value = max_time
	progress_time_bar_2.value = max_time


func _on_time_changed(time_left: float , max_level_time):
	progress_time_bar.value = time_left 
	progress_time_bar_2.value = time_left
	# Cambiar color si el tiempo es crítico
	if time_left < max_level_time * 0.2:
		progress_time_bar.add_theme_color_override("font_color", Color.RED)
		progress_time_bar_2.add_theme_color_override("font_color", Color.RED)

func _on_time_ended():
	progress_time_bar.value = progress_time_bar.max_value
	progress_time_bar_2.value = progress_time_bar.max_value
