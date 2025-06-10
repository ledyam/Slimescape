extends PlayerState


func enter():
	print (">> ESTADO ATACK <<")
	Animaciones()
	pass 

func Animaciones ():
	
	match player.current_direction:
		player.direction.up :
			player.anim_movement.play(AnimationsNames.animations._attack_up)
			
		player.direction.down:
			player.anim_movement.play(AnimationsNames.animations._attack)
			
		player.direction.none:
			player.anim_movement.play(AnimationsNames.animations._attack)
			
		player.direction.left :
			player.anim_movement.play(AnimationsNames.animations._attack_turnL)
			
		player.direction.right :
			player.anim_movement.play(AnimationsNames.animations._attack_turnR)
			



func _on_animation_player_movements_animation_finished(anim_name: StringName) -> void:
	var attack_animations =  [
 		'attack_down',
 		'attack_up',
 		'attack_left',
		'attack_right']
	
	if anim_name in attack_animations:
		state_machine.change_to(state_machine.history.back())
