extends PlayerState


func enter ():
	print (">> ESTADO IDLE <<")
	update_idle_animations()
	
func update_idle_animations () -> void :
	
	match player.current_direction:  
		player.direction.none:
			player.anim_movement.play()
		player.direction.up :
			player.anim_movement.play("jump")
		player.direction.left :
			player.anim_movement.play("move_left")
		player.direction.right : 
			player.anim_movement.play("move_left")

func physics_process(delta: float) -> void:
		if not player.is_on_floor():
			player.velocity += player.get_gravity() * delta
			
		if Input.is_action_just_pressed("W") and player.is_on_floor():
			player.velocity.y = player.JUMP_VELOCITY
