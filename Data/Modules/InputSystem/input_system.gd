extends Control
@export_category("Left Hand")
@export var left_up_button: Button
@export var left_left_button: Button
@export var left_right_button: Button


@export_category("Right Hand")
@export var right_up_button: Button
@export var right_left_button: Button
@export var right_right_button: Button



@export var reset_button: Button

const ACTIONS = {
	"left_up": "left_move_up",
	"left_left": "left_move_left",
	"left_right": "left_move_right",
	"right_up": "right_move_up",
	"right_left": "right_move_left",
	"right_right": "right_move_right",
	"space" : "reset"
}



var label_text_unassigned = "Unassigned"
var waiting_for_input: String = ""
 
func _ready():
	_update_button_labels()
 
	left_up_button.pressed.connect(_on_rebind_button_pressed.bind("left_up"))
	left_left_button.pressed.connect(_on_rebind_button_pressed.bind("left_left"))
	left_right_button.pressed.connect(_on_rebind_button_pressed.bind("left_right"))
	
	right_up_button.pressed.connect(_on_rebind_button_pressed.bind("right_up"))
	right_left_button.pressed.connect(_on_rebind_button_pressed.bind("right_left"))
	right_right_button.pressed.connect(_on_rebind_button_pressed.bind("right_right"))
	reset_button.pressed.connect(_on_rebind_button_pressed.bind("space"))
	
func _get_button(direction: String) -> Button:
	match direction:
		"left_up": return left_up_button
		"left_left": return left_left_button
		"left_right": return left_right_button
		"right_up" :  return  right_up_button
		"right_left" : return right_left_button
		"right_right" : return right_right_button
		"space": return reset_button
		_: return null
		
		
func _get_button_letter(keycode: int) -> Button:
	for dir in ACTIONS:
		if _get_button(dir).text == InputManager.get_key_name(keycode):
			return _get_button(dir)
	return null 


func _update_button_label(direction: String):
	var action_name = ACTIONS[direction]

	var events = InputMap.action_get_events(action_name)
 
	var btn = _get_button(direction)
	btn.text = InputManager.get_key_name(InputManager.get_primary_key(action_name))
 
func _update_button_labels():
	for dir in ACTIONS.keys():
		_update_button_label(dir)

 
func _on_rebind_button_pressed(direction: String):
	waiting_for_input = direction
	var btn = _get_button(direction)
	btn.text = "..."
	set_process_input(true)
 
func _input(event):
	if waiting_for_input == "":
		return
 
	if event is InputEventKey and event.pressed:
		var direction = waiting_for_input
		var action_name = ACTIONS[direction]

		if InputManager.is_key_used(event.keycode) and _get_button_letter(event.keycode) != null: 
			var btn = _get_button_letter(event.keycode)
			btn.text = label_text_unassigned
			InputMap.action_erase_events(ACTIONS[btn.name.to_lower()])
		InputManager.rebind_action(action_name,event.keycode)
		_update_button_label(direction)

		waiting_for_input = ""
		set_process_input(false)
 
