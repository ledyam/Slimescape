extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	ControlUi.hide()
	ControlUi.canvas_layer.hide()
	$AudioStreamPlayer.stream.loop = true
	$VideoStreamPlayer.play()
	animation_player.play("oclution")
	await animation_player.animation_finished
	$GuiTransition._show()


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_iniciar_pressed() -> void:
	$GuiTransition._hide()
	animation_player.play("oclution_2")
	await animation_player.animation_finished
	ControlUi.show()
	ControlUi.canvas_layer.show()
	get_tree().change_scene_to_file("res://Data/Levels/level_1.tscn")


func _on_sound_pressed() -> void:
	if$AudioStreamPlayer.playing:
		$AudioStreamPlayer.stream_paused = true
	else:
		$AudioStreamPlayer.stream_paused = false 
	pass # Replace with function body.


func _on_screen_pressed() -> void:
	if get_window().mode == Window.MODE_FULLSCREEN:
		get_window().mode = Window.MODE_MAXIMIZED
	else : 
		get_window().mode = Window.MODE_FULLSCREEN
	pass # Replace with function body.
