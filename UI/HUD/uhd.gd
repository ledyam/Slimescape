extends CanvasLayer


@onready var hud_contanier: Control = $HUDContanier
@onready var current_level_label: Label = %CurrentLevelLabel
@onready var level_max_label_2: Label = %LevelMaxLabel2
@onready var timer_bar: Panel = $HUDContanier/TimerBar
@onready var timer_bar_2: Panel = $HUDContanier/TimerBar2

func _ready() -> void:
	LevelManager.connect("level_changed",on_level_changed)
	GameSession.connect("attempt_change", on_attempt_change)


	
func on_level_changed(current_level : int ):
	%CurrentLevelLabel.text = str(current_level)

func on_attempt_change(current_attempts : int ):
	%AttemptLabel.text = str(current_attempts)
