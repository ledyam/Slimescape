extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.play_music("res://Assets/Sounds/timex27s-running-out-151012.mp3", 1.0)
	$AnimationPlayer.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
