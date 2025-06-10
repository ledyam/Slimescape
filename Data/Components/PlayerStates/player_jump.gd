extends PlayerState


func physics_process(_delta: float) -> void:
	if player.is_moving : 
		var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		player.mru_2d.direction_2d = input_direction
		if Input.is_action_pressed("Jump"):
			AnimacionesCombinadas()
		elif Input.is_action_pressed(" JumpIdle"):      
			Animaciones()
		player.mru_2d.move()
	else : 
		Animaciones()


func Animaciones():
	match player.current_direction:
		player.direction.none:
			player.anim_movement.play("Player_idle_jump_front")
		player.direction.down:
				player.anim_movement.play("Player_idle_jump_front")
		player.direction.up:
				player.anim_movement.play("Player_idle_jump_back")
		player.direction.left:
			player.anim_movement.play("Player_idle_jump_left")
		player.direction.right:
			player.anim_movement.play("Player_idle_jump_right")
			
func AnimacionesCombinadas():
	match player.current_direction:
		player.direction.none:
			player.anim_movement.play("Player_jump_front")
		player.direction.down:
				player.anim_movement.play("Player_jump_front")
		player.direction.up:
				player.anim_movement.play("Player_jump_back")
		player.direction.left:
			player.anim_movement.play("Player_jump_left")
		player.direction.right:
			player.anim_movement.play("Player_jump_right")
			


func _on_animation_player_movements_animation_finished(anim_name: StringName) -> void:
	var jump_animations = [
		"Player_jump_back", 
		"Player_jump_front", 
		"Player_jump_left", 
		"Player_jump_right",
		"Player_idle_jump_back",
		"Player_idle_jump_front",
		"Player_idle_jump_left",
		"Player_idle_jump_right"
		]
	if anim_name in jump_animations:
		if player.is_moving:
			state_machine.change_to(StatesName.states._walk)
		else:
			state_machine.change_to(StatesName.states._idle)
