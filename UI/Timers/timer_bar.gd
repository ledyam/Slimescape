extends HBoxContainer

@onready var progress_time_bar: ProgressBar = $ProgressTimeBar
@onready var progress_time_bar_2: ProgressBar = $ProgressTimeBar2



const NORMALIZED_TIMER : int = 1 
func _ready():
	progress_time_bar.max_value = LevelManager.get_time_level()
	progress_time_bar_2.max_value = progress_time_bar.max_value
	LevelTimeManager.level_time_changed.connect(_on_time_changed)
	LevelTimeManager.level_time_ended.connect(_on_time_ended)
	LevelTimeManager.level_time_reset.connect(_on_time_ended)


func _on_time_changed(time_left: float , _max_level_time):
	progress_time_bar.value = time_left
	progress_time_bar_2.value = time_left
	
func _on_time_ended():
	progress_time_bar.value = progress_time_bar.max_value
	progress_time_bar_2.value =  progress_time_bar.max_value
