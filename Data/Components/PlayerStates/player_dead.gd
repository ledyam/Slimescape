extends PlayerState
@onready var timer: Timer = $"../../Timers/Tiempo_de_muerte"
func enter ():
	print (">> State DEAD <<")
	
	stop_player()
	handle_death_animation()
	timer.start()

func stop_player() -> void : 
	player.is_moving = false 

func handle_death_animation() -> void : 
	
	match player.current_direction:
		player.direction.none:
			player.anim_movement.play(AnimationsNames.animations._dead_down)
		player.direction.up :
			player.anim_movement.play(AnimationsNames.animations._dead_up)

		player.direction.down :
			player.anim_movement.play(AnimationsNames.animations._dead_down)

		player.direction.left :
			player.anim_movement.play(AnimationsNames.animations._dead_left)

		player.direction.right : 
			player.anim_movement.play(AnimationsNames.animations._dead_right)
