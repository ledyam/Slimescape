extends CanvasLayer




@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	LevelManager.connect("level_changed",on_level_changed)
	GameSession.connect("attempt_change", on_attempt_change)
	animation_player.play('default')

	
func on_level_changed(current_level : int ):
	%CurrentLevelLabel.text = str(current_level)

func on_attempt_change(current_attempts : int ):
	%AttemptLabel.text = str(current_attempts)
