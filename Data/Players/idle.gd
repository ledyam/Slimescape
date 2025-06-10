extends PlayerState


func enter ():
	player.is_moving = false
	if player.is_on_floor():
		update_idle_animations()

	
func update_idle_animations () -> void :
	match player.current_direction:  
		player.direction.left :
			player.anim_movement.play("move_left")
		player.direction.right : 
			player.anim_movement.play("move_left")

func physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		
	if  Input.is_action_just_pressed(player.movement_left._jump) and player.is_on_floor():
		player.anim_movement.play("jump")
		player.velocity.y = player.JUMP_VELOCITY
	
	elif  Input.is_action_just_pressed(player.movement_left._izq):
		player.is_moving = true
		state_machine.change_to("Move")
	elif Input.is_action_just_pressed(player.movement_left._der) :
		player.is_moving = true
		state_machine.change_to("Move")
		
	player.move_and_slide()
	
