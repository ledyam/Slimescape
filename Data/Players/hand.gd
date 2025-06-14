extends CharacterBody2D

class_name MainCharacter

const SPEED = 140.0
const JUMP_VELOCITY = -350.0
var leaved_floor : bool = false 
var is_jumping : bool = false
var has_started : bool = false  
var double_jump : bool = false 


func started_timer():
	CentralSignal.play_movement.emit()



func _ready() -> void:
	CentralSignal.double_jump.connect(on_double_jump)
	

func on_double_jump():
	double_jump = true
	pass

func tile_collision():
	var tilemap : TileMapLayer = get_tree().get_first_node_in_group("tilemap")
	if tilemap:
		
		var local_position = tilemap.to_local(global_position)
		var tile_coords = tilemap.local_to_map(local_position)
		var tile_data: TileData = tilemap.get_cell_tile_data( tile_coords)  # <-- Aquí agregamos el layer 0

		if tile_data and tile_data.get_custom_data("es_pincho"):
		
			ControlUi.reset_level()
