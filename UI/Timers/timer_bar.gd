extends PanelContainer

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	LevelTimeManager.level_time_started.connect(_on_time_started)
	LevelTimeManager.level_time_changed.connect(_on_time_changed)
	LevelTimeManager.level_time_ended.connect(_on_time_ended)
	LevelTimeManager.level_time_reset.connect(_on_time_ended)
	
func _on_time_started(max_time: float):
	progress_bar.max_value = max_time
	progress_bar.value = max_time


func _on_time_changed(time_left: float , max_level_time):
	progress_bar.value = time_left 

	# Cambiar color si el tiempo es crítico
	if time_left < max_level_time * 0.2:
		progress_bar.add_theme_color_override("font_color", Color.RED)


func _on_time_ended():
	progress_bar.value = progress_bar.max_value
