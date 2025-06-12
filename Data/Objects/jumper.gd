extends Node2D

@export var is_active : bool 
@export var is_push : bool 
var is_player_in : bool = false
# Called when the node enters the scene tree for the first time.
var player_reference : CharacterBody2D
func _ready() -> void:
	CentralSignal.active_jumper.connect(on_active_jumper)
	if !is_push:
		$AnimationPlayer.play('up')
	else :
		$AnimationPlayer.play('down')

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D: 
		is_player_in = true
		player_reference = body
		if !is_active:
			$AnimationPlayer.play("fetch")
			CentralSignal.active_jumper.emit()
			is_active = true
			
func on_active_jumper():
	if is_push and is_active:
		$AnimationPlayer.play("push")
		if is_player_in:
			player_reference.velocity.y += -500
	


func _on_area_2d_body_exited(body: Node2D) -> void:
	is_player_in = false 
	pass # Replace with function body.
