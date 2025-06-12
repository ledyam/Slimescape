extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Esc"):
		if get_tree().paused:
			self.hide()
			get_tree().paused = false
		else : 
			get_tree().paused = true
			self.show()


func _on_button_continuar() -> void:
	get_tree().paused = true
	self.hide()




func _on_salir_pressed() -> void:
	get_tree().quit()
