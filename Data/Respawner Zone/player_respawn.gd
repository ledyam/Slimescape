extends Marker2D

var left_hand : PackedScene = preload("res://Data/Characters/Players/left_hand.tscn")
var right_hand: PackedScene = preload("res://Data/Characters/Players/right_hand.tscn")

@export_enum("RED","BLUE") var ID : int 


func _ready() -> void:
	
	if ID == 0 : 
		instantiate_hand(left_hand)
	else : 
		instantiate_hand(right_hand)
		
	
	
	
func instantiate_hand(hand : PackedScene) -> void:
	var hand_instantiate = hand.instantiate()
	# Añade el hijo de forma segura con call_deferred
	get_tree().current_scene.call_deferred("add_child", hand_instantiate)
	hand_instantiate.global_position = self.global_position  # Asigna la posición después
