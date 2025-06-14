extends Sprite2D

@export var door : NodePath
	
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D: 
		get_node(door).open_door()
		queue_free()
