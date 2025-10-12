extends CanvasLayer
signal other_screen_closed

@onready var pausable_background: ColorRect = $Control/PausableBackground
var paused : bool = false 

func _ready() -> void:

	other_screen_closed.connect(on_other_screen_closed)
	
func _input(event: InputEvent) -> void:
	
	#if GameSession.is_pausable_moment():
		if Input.is_action_just_pressed("Esc") and not is_other_screen_open():
			if paused:
				paused_off()
			else : 
				paused_on()
			
		elif Input.is_action_just_pressed("Esc") and is_other_screen_open() : 
			$Control/MenuOptions.hide()
			$Control/NinePatchRect.show()

func paused_on() -> void :
	paused = true
	get_tree().paused = true
	self.show()
	
func paused_off() -> void :
	paused = false 
	get_tree().paused = false
	self.hide()
	
func is_other_screen_open():
	return $Control/MenuOptions.visible
	
func on_other_screen_closed():
	$Control/NinePatchRect.show()

func _on_button_continuar() -> void:
	paused_off() 

func _on_salir_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	$Control/NinePatchRect.hide()
	GuiTransitions.show("MenuOptions")
	
