extends PlayerState

func enter():
	print (">> ESTADO MOVE <<")
	player.is_moving = true

func physics_process(_delta):
	
	if player.is_sprinting:
		state_machine.change_to(StatesName.states._run)
		return
		
	elif player.is_moving and !player.is_sprinting  :
		Mover()
	else :
		state_machine.change_to(StatesName.states._idle)

func Establecer_Animacciones ():
	
	if Input.is_action_pressed('ui_up'):
		set_current_direction(player.direction.up)
		player.anim_movement.play(AnimationsNames.animations._walk_up)
	elif  Input.is_action_pressed("ui_down"):
		set_current_direction(player.direction.down)
		player.anim_movement.play(AnimationsNames.animations._walk_down)
	elif  Input.is_action_pressed('ui_right'):
		set_current_direction(player.direction.right)
		player.anim_movement.play(AnimationsNames.animations._walkr)
	elif  Input.is_action_pressed('ui_left'):
		set_current_direction(player.direction.left)
		player.anim_movement.play(AnimationsNames.animations._walkl)
	else :
		state_machine.change_to(StatesName.states._idle)

func Mover ():
	Establecer_Animacciones ()
	var input_direction = Input.get_vector("ui_left","ui_right",'ui_up',"ui_down")
	player.mru_2d.direction_2d = input_direction
	player.mru_2d.move()
	
