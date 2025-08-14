extends CharacterBody2D

class_name MainCharacter

@export_enum("RED", "BLUE") var ID : int 

@export var input_map : Dictionary = {
	JUMP = "W",
	LEFT = "A",
	RIGHT = "D"
}

@export var SPEED = 145.0
const JUMP_VELOCITY = -355.0

var leaved_floor : bool = false 
var is_jumping : bool = false
var has_started : bool = false  
var double_jump : bool = false 
var invert_gravity : bool  = false 
var is_moving : bool = false 

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var double_jump_timer: Timer = $Timers/DoubleJumpTimer


func _ready() -> void:
	if ID == 0 : 
		$AnimatedSprite2D.sprite_frames = load("res://Data/Resources/Character/AnimatedSprites/red_slime.tres")
	else :
		$AnimatedSprite2D.sprite_frames = load("res://Data/Resources/Character/AnimatedSprites/blue_slime.tres")
	
	CentralSignal.active_buff.connect(on_active_buff)

func _physics_process(delta: float) -> void:
	
	
	if   is_on_floor():
		if !is_moving:
			animation_player.play("idle")
		coyote_timer.stop()
		is_jumping = false 
		leaved_floor = false

		
	if  not is_on_floor():
		animation_player.play("jump")
		if not leaved_floor and coyote_timer.is_stopped(): 
			leaved_floor = true
			coyote_timer.start()
			 
		if !invert_gravity: 
			velocity += get_gravity() * delta
		else : 
			velocity -= get_gravity() * delta
	if Input.is_action_just_pressed(input_map.JUMP) and can_jump():
		_handle_jump()
		
	_handle_movement()
	move_and_slide()
	tile_collision()
	
func move(direction) -> void :
	 
	$AnimatedSprite2D.flip_h = direction > 0
	if !invert_gravity:
		if not is_on_floor():
			animation_player.play("jump")
		else : 
			animation_player.play("move")
	else : 
		animation_player.play("vertical_move")
	velocity.x = direction * SPEED

func _handle_jump():
	$JumpParticles2D.emitting = true
	$"Sound/Jump".play()
	if !has_started:
		has_started = true
		started_timer()
		
	if !invert_gravity:
		velocity.y = JUMP_VELOCITY
	else :
		velocity.y = -JUMP_VELOCITY
		
	is_jumping = true
	coyote_timer.stop()

func _handle_movement():
	
	var direction := Input.get_axis(input_map.LEFT, input_map.RIGHT)
	if direction:
		is_moving = true
		if !has_started:
			has_started = true
			started_timer()
			
		move(direction)
	else:
		
		is_moving = false 
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

func started_timer():
	if !LevelTimeManager.is_running:
		CentralSignal.emit_signal("player_in_movement")

func on_active_buff(player_id : int  , buff_type : int ) -> void : 
	if player_id == ID:
		match  buff_type:
			Buff.Type.DOUBLE_JUMP: 
				active_double_jump()
			Buff.Type.CHANGE_GRAVITY:
				active_change_gravity()


		$Sound/Buff.play()
	pass

func active_double_jump() -> void:
	double_jump = true
	double_jump_timer.start()
	pass

func active_change_gravity() -> void :
	if !invert_gravity:
		up_direction = Vector2.DOWN
		invert_gravity = true
	else : 
		invert_gravity = false
		up_direction = Vector2.UP

func tile_collision():

	var tilemaps  = get_tree().get_nodes_in_group("obstacles")
	for tilemap in tilemaps:
		
		if tilemap:
			var local_position = tilemap.to_local(global_position)
			var tile_coords = tilemap.local_to_map(local_position)
			var tile_data: TileData = tilemap.get_cell_tile_data( tile_coords)  # <-- Aquí agregamos el layer 0
			if tile_data and tile_data.get_custom_data("is_pike"):
				LevelManager.restart_level()

func can_jump():
	if is_jumping and double_jump  : 
		double_jump = false 
		double_jump_timer.stop()
		return true
	if is_on_floor() and !is_jumping  : return true
	elif !is_jumping and !coyote_timer.is_stopped() : return  true 
 
func _change_scene():
	LevelManager._get_to_transition()

func _on_double_jump_timer_timeout() -> void:
	double_jump = false 

func _on_hit_box_body_entered(body):
	if body is MainCharacter:
		if !body.ID == ID:
			
			call_deferred("_change_scene")
