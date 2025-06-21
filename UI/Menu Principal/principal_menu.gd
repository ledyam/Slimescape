extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gui_transition: Node = $CanvasLayer/GuiTransition



func _ready() -> void:
	MusicManager.play_music("res://Assets/Sounds/principal_menu_audio.mp3")
	PausableMenu.process_mode =Node.PROCESS_MODE_DISABLED
	animation_player.play("oclution")
	%BackgroundVideo.play()
	await animation_player.animation_finished
	gui_transition._show()


func _on_salir_pressed() -> void:
	get_tree().quit()


func _on_iniciar_pressed() -> void:
	gui_transition._hide()
	%BackgroundVideo.stream = load("res://Assets/Videos/Init Game.ogv")
	%BackgroundVideo.play()
	animation_player.play("oclution_2")
	await animation_player.animation_finished
	PausableMenu.process_mode =Node.PROCESS_MODE_ALWAYS
	HUD.show()
	get_tree().change_scene_to_file("res://Data/Levels/level_tutorial.tscn")


func _on_sound_pressed() -> void:
	if !MusicManager.is_paused():
		MusicManager.set_paused(true)
		%Sound.icon = load("res://Assets/icons/Lucid V1.2/PNG/Flat/16/Speaker-Crossed.png")
	else:
		MusicManager.set_paused(false)
		%Sound.icon = load("res://Assets/icons/Lucid V1.2/PNG/Flat/16/Speaker-1.png")
	pass # Replace with function body.


func _on_screen_pressed() -> void:
	if get_window().mode == Window.MODE_FULLSCREEN:
		%Screen.icon = load("res://Assets/icons/Lucid V1.2/PNG/Flat/16/Cursor-3.png")
		get_window().mode = Window.MODE_MAXIMIZED
	else : 
		%Screen.icon = load("res://Assets/icons/Lucid V1.2/PNG/Flat/16/Cursor-7.png")

		get_window().mode = Window.MODE_FULLSCREEN
	pass # Replace with function body.


func _on_discord_pressed() -> void:
	OS.shell_open("https://discord.com/channels/1335690370436169728/1335690370498957479")


func _on_telegram_pressed() -> void:
	OS.shell_open("https://web.telegram.org/a/#-1002377548371_1")


func _on_opciones_pressed() -> void:
	GuiTransitions.show("MenuOptions")
	pass # Replace with function body.
