extends CanvasLayer
signal other_screen_closed

var is_paused : bool = false 

func _ready() -> void:
	self.hide()

	
func _unhandled_input(event: InputEvent) -> void:
	#if GameSession.is_pausable_moment():
		if Input.is_action_just_pressed("ui_cancel"):
			if is_paused:
				paused_off()
			else : 
				paused_on()


func paused_on() -> void :
	is_paused = true
	get_tree().paused = true
	self.show()
	
func paused_off() -> void :
	is_paused = false 
	get_tree().paused = false
	self.hide()


func _on_button_continuar() -> void:
	paused_off() 

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	GuiTransitions.show("MenuOptions")
	
