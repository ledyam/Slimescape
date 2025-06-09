extends CanvasLayer


var wips : int = 0
var current_level = 0 
var RESTANT_TIMER = 8
const FINAL_TIME = 0


func _ready() -> void:
	CentralSignal.increment_level.connect(on_increment_level)
	$AnimationPlayer.play("timer")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
		restart_timer()

func _process(delta: float) -> void:
	%ProgressBar.value -= RESTANT_TIMER * delta
	%ProgressBar2.value -=RESTANT_TIMER * delta
	if %ProgressBar.value == FINAL_TIME : 
		increment_wip()
		restart_timer()
		
		
		
func on_increment_level() -> void : 
	current_level += 1
	%LevelLabel.text = str(current_level)


func restart_timer() -> void : 
	%ProgressBar.value = 100
	%ProgressBar2.value = 100
	get_tree().reload_current_scene()
		
		


func increment_wip() -> void :
	wips += 1
	%WipsLabel.text = str(wips)
