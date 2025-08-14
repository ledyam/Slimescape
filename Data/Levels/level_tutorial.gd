extends Node2D


func _ready() -> void:
	GameSession.GAME_ON()
	#await Dialogic.timeline_ended
	#MusicManager.play_music("res://Assets/Sounds/timex27s-running-out-151012.ogg")
	$KewordZone/AnimationPlayer.play('default')
	
