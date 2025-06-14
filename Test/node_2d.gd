extends  Control

var time_elapsed = 0.0  # Tiempo transcurrido en segundos
var is_running = false  # Estado del cronómetro

func _process(delta):
	if is_running:
		time_elapsed += delta
		update_display()  # Actualiza la UI (opcional)

func start():
	is_running = true

func stop():
	is_running = false

func reset():
	time_elapsed = 0.0


func update_display():
	var minutes = int(time_elapsed) / 60
	var seconds = int(time_elapsed) % 60
	var milliseconds = int((time_elapsed - int(time_elapsed)) * 100)
	# Formato MM:SS:MS
	$Label.text = ("%02d:%02d:%02d"%[minutes, seconds, milliseconds])


func _on_button_pressed() -> void:
	if !is_running:
		start()
	else : 
		stop()
	pass # Replace with function body.
