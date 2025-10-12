extends Control
 
@export var up_button: Button
@export var down_button: Button
@export var left_button: Button
@export var right_button: Button
 
const ACTIONS = {
	"up": "move_up",
	"down": "move_down",
	"left": "move_left",
	"right": "move_right"
}

var label_text_unassigned = "Unassigned"
var waiting_for_input: String = ""
 
func _ready():
	InputManager._ready()
	_update_button_labels()
 
	up_button.pressed.connect(_on_rebind_button_pressed.bind("up"))
	down_button.pressed.connect(_on_rebind_button_pressed.bind("down"))
	left_button.pressed.connect(_on_rebind_button_pressed.bind("left"))
	right_button.pressed.connect(_on_rebind_button_pressed.bind("right"))
 
func _get_button(direction: String) -> Button:
	match direction:
		"up": return up_button
		"down": return down_button
		"left": return left_button
		"right": return right_button
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
 
