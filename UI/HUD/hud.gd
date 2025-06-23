extends CanvasLayer


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	LevelManager.connect("level_changed",on_level_changed)
	GameSession.connect("attempt_change", on_attempt_change)
	animated_sprite_2d.play("default")

	
func on_level_changed(current_level : int ):
	%CurrentLevelLabel.text = str(current_level)

func on_attempt_change(current_attempts : int ):
	%AttemptLabel.text = str(current_attempts)
