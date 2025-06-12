extends Node2D

## Configuración exportable
@export var move_distance: Vector2 = Vector2(300, 0)  # Distancia de movimiento
@export var move_speed: float = 1.5  # Velocidad base del movimiento
@export var rotation_speed: float = 180  # Grados por segundo de rotación
@export var start_delay: float = 0.5  # Tiempo antes de empezar a moverse


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Area2D

func _ready():
	animated_sprite.play("default")
	setup_movement()
	setup_hitbox()

func setup_movement():
	var tween = create_tween()
	tween.set_loops()  # Bucle infinito
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)  # Más preciso para gameplay
	
	# Movimiento de ida con easing pendular
	tween.tween_property(self, "global_position", self.global_position + move_distance, move_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)\
		.set_delay(start_delay)
	
	# Movimiento de vuelta con easing pendular
	tween.tween_property(self, "global_position", self.global_position, move_speed)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	# Rotación continua
	var rotation_tween = create_tween()
	rotation_tween.tween_property(self, "rotation_degrees", 360, 360/rotation_speed)\
		.set_trans(Tween.TRANS_LINEAR)
	rotation_tween.set_loops()

func setup_hitbox():
	hitbox.body_entered.connect(_on_body_entered)
	# Ajusta la forma de colisión para que coincida mejor con la sierra
	var collision = hitbox.get_node("CollisionShape2D")
	if collision:
		collision.shape.radius = animated_sprite.sprite_frames.get_frame_texture("default", 0).get_width() / 2

func _on_body_entered(body: Node2D):
	if body is CharacterBody2D:
		# En un juego real, aquí iría el sistema de daño al jugador
		print("¡Jugador golpeado por la sierra!")
		ControlUi.reset_level()  
		
		
	
