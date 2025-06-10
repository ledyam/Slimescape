

extends PlayerState

func enter():
	print("Estado MOVE")

func physics_process(delta: float) -> void:
	
	if player.is_moving :
		if not player.is_on_floor():
			player.velocity += player.get_gravity() * delta
		handle_animation()
		move()
		player.move_and_slide()

	if  Input.is_action_just_pressed(player.movement_left._jump) and player.is_on_floor():
		player.anim_movement.play("jump")
		player.velocity.y = player.JUMP_VELOCITY
		
	if player.is_moving:
		handle_animation()
		move()
		player.move_and_slide()
	else :
		state_machine.change_to("Idle")

func handle_animation():
	if  Input.is_action_pressed(player.movement_left._izq):
		player.anim_movement.play("move_left")
		
	elif Input.is_action_pressed(player.movement_left._der) :
		player.anim_movement.play("move_right")

func move():
	var input_direction = Input.get_axis("A","D")
	player.velocity.x = input_direction * player.SPEED
