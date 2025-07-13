extends HBoxContainer

@onready var progress_time_bar: ProgressBar = $ProgressTimeBar
var bar_shader : ShaderMaterial
const NORMALIZED_TIMER : int = 1 
func _ready():

	LevelTimeManager.level_time_changed.connect(_on_time_changed)
	LevelTimeManager.level_time_ended.connect(_on_time_ended)
	LevelTimeManager.level_time_reset.connect(_on_time_ended)
	bar_shader = progress_time_bar.material

func _on_time_changed(time_left: float , max_level_time):
	bar_shader.set_shader_parameter("progress",time_left/max_level_time) 

func _on_time_ended():
	bar_shader.set_shader_parameter("progress",NORMALIZED_TIMER) 
