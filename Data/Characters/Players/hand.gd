extends CharacterBody2D

class_name MainCharacter

@export_enum("RED", "BLUE") var ID : int 

@export var input_map : Dictionary = {
	JUMP = "W",
	LEFT = "A",
	RIGHT = "D"
}

const SPEED = 140.0
const JUMP_VELOCITY = -350.0
var leaved_floor : bool = false 
var is_jumping : bool = false
var has_started : bool = false  
var double_jump : bool = false 
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coyote_timer: Timer = $Timers/CoyoteTimer


func _ready() -> void:
	if ID == 0 : 
		$AnimatedSprite2D.sprite_frames = load("res://Data/Resources/Character/AnimatedSprites/red_slime.tres")
	else :
		$AnimatedSprite2D.sprite_frames = load("res://Data/Resources/Character/AnimatedSprites/blue_slime.tres")
	CentralSignal.double_jump.connect(on_double_jump)
	
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
	if Input.is_action_just_pressed(input_map.JUMP) and can_jump():
		$"Sound/Jump".play()
		if !has_started:
			has_started = true
			started_timer()
			
		
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		coyote_timer.stop()


	var direction := Input.get_axis(input_map.LEFT, input_map.RIGHT)
	if direction:
		if !has_started:
			has_started = true
			started_timer()
			
		move(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	tile_collision()
	
	
func move(direction) -> void : 
	
	$AnimatedSprite2D.flip_h = direction > 0
	animation_player.play("move")
	velocity.x = direction * SPEED
	
func started_timer():
	if !LevelTimeManager.is_running:
		CentralSignal.player_is_movement.emit()


func on_double_jump():
	double_jump = true
	$DoubleJumpTimer.start()
	pass

func tile_collision():

	var tilemaps  = get_tree().get_nodes_in_group("tilemap")
	for tilemap in tilemaps:
		
		if tilemap:
			var local_position = tilemap.to_local(global_position)
			var tile_coords = tilemap.local_to_map(local_position)
			var tile_data: TileData = tilemap.get_cell_tile_data( tile_coords)  # <-- Aquí agregamos el layer 0
			if tile_data and tile_data.get_custom_data("es_pincho"):
				ControlUi.reset_level()

func can_jump():
	if is_jumping and double_jump  : 
		double_jump = false 
		$DoubleJumpTimer.stop()
		return true
	if is_on_floor() and !is_jumping  : return true
	elif !is_jumping and !coyote_timer.is_stopped() : return  true 
 
func _change_scene():
	LevelManager._get_to_transition()

func _on_double_jump_timer_timeout() -> void:
	double_jump = false 
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	if body is MainCharacter:
		if !body.ID == ID: 
			call_deferred("_change_scene")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameSession.add_attempt()
		LevelManager.restart_level()
		LevelTimeManager.reset_level_timer()
