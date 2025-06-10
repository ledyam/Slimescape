extends MainCharacter

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("W") and is_on_floor():
		animation_player.play("jump")
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("A", "D")
	if direction:
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
