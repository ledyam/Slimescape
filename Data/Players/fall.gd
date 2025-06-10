
extends PlayerState


func enter ():
	print("ESTADO FALL")

		
func physics_process(delta: float) -> void:
	
	if !player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		if  Input.is_action_pressed("A"):
			state_machine.change_to("Move")
		if Input.is_action_pressed("D") :
			state_machine.change_to("Move")
		
	else : 
		state_machine.change_to("Idle")
		
	player.move_and_slide()
