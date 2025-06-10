extends MainCharacter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $coyote_timer


func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		coyote_timer.stop()
		is_jumping = false 
		leaved_floor = false 
		
		
	if not is_on_floor():
		if not leaved_floor and coyote_timer.is_stopped(): 
			leaved_floor = true
			coyote_timer.start()
		velocity += get_gravity() * delta
		

	# Handle jump.
	if Input.is_action_just_pressed("W") and can_jump():
		if !has_started:
			has_started = true
			started_timer()
		
		
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		coyote_timer.stop()


	var direction := Input.get_axis("A", "D")
	if direction:
		if !has_started:
			has_started = true
			started_timer()
		if direction < 0 : 
			$AnimatedSprite2D.flip_h = false
			animation_player.play("move_left")
			velocity.x = direction * SPEED
		else : 
			$AnimatedSprite2D.flip_h = true
			animation_player.play("move_left")
			velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func can_jump():
	if is_on_floor() and !is_jumping  : return true
	elif !coyote_timer.is_stopped() : return  true 
	 
	
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "RightHand":
		CentralSignal.increment_level.emit()
		CentralSignal.pause_movement.emit()
	
		get_tree().change_scene_to_file("res://UI/transition_level.tscn")
	pass # Replace with function body.
