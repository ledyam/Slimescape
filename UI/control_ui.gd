extends CanvasLayer


var wips : int = 0
var current_level : int = 0 
var RESTANT_TIMER = 8
const FINAL_TIME = 0
var exist_movement_hand : bool = false 

func _ready() -> void:
	CentralSignal.increment_level.connect(on_increment_level)
	CentralSignal.play_movement.connect(on_play_movement)
	CentralSignal.pause_movement.connect(on_pause_movement)
	$AnimationPlayer.play("timer")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
		restart_timer()

func _process(delta: float) -> void:
	if exist_movement_hand:
		%ProgressBar.value -=  RESTANT_TIMER * delta
		%ProgressBar2.value -= RESTANT_TIMER * delta
		if %ProgressBar.value == FINAL_TIME : 
			increment_wip()
			restart_timer()
			get_tree().reload_current_scene()
		
		
		
		
	
func on_pause_movement():
	exist_movement_hand = false
	
	
func on_play_movement():
	exist_movement_hand = true
	
	 
func on_increment_level() -> void : 
	current_level += 1
	%LevelLabel.text = str(current_level)


func restart_timer() -> void : 
	%ProgressBar.value = 100
	%ProgressBar2.value = 100

func increment_wip() -> void :
	wips += 1
	%WipsLabel.text = str(wips)
