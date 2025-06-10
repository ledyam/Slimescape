extends PlayerState

func enter():
	print (">> ESTADO RUN <<")


func physics_process(_delta):
	
	if player.is_sprinting:
		move()
	else  :
		state_machine.change_to(StatesName.states._walk)


func hadle_run_animations():
	if Input.is_action_pressed('ui_up') and  Input.is_action_pressed('run'):
		set_current_direction(player.direction.up)
		player.anim_movement.play(AnimationsNames.animations._run_up)
		
	elif Input.is_action_pressed('ui_down') and  Input.is_action_pressed('run'):
		set_current_direction(player.direction.down)
		player.anim_movement.play(AnimationsNames.animations._run_down)
		
	elif Input.is_action_pressed('ui_left') and  Input.is_action_pressed('run'):
		set_current_direction(player.direction.left)
		player.anim_movement.play(AnimationsNames.animations._run_left)
		
	elif Input.is_action_pressed('ui_right') and  Input.is_action_pressed('run'):
		set_current_direction(player.direction.right)
		player.anim_movement.play(AnimationsNames.animations._run_right)
		
	elif Input.is_action_pressed('run_up'):
		set_current_direction(player.direction.up)
		player.anim_movement.play(AnimationsNames.animations._run_up)
	elif  Input.is_action_pressed("run_down"):
		set_current_direction(player.direction.down)
		player.anim_movement.play(AnimationsNames.animations._run_down)
	elif  Input.is_action_pressed('run_right'):
		set_current_direction(player.direction.right)
		player.anim_movement.play(AnimationsNames.animations._run_right)
	elif  Input.is_action_pressed('run_left'):
		set_current_direction(player.direction.left)
		player.anim_movement.play(AnimationsNames.animations._run_left)
	else :
		state_machine.change_to(StatesName.states._idle)

func estabilished_move_direction():
	var run_input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction_input = Input.get_vector("run_left", "run_right", "run_up", "run_down")
	var combined_input = direction_input if direction_input != Vector2.ZERO else run_input
	
	player.mru_2d.direction_2d = combined_input
	player.mru_2d.move()
	
func move():
	hadle_run_animations()
	estabilished_move_direction()
	
