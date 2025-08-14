extends Control

@export var intro: AnimationPlayer 
const ANIMATION_NAME = "Intro"
var scene_timelap : int = 1
@onready var rich_text_label: RichTextLabel = $RichTextLabel

var markers : Dictionary = {
	1:"Primero",
	2:"Segundo",
	3:"Tercero",
	4:"Cuarto",
	5:"Quinto"
}
func _ready() -> void:
	intro.play(ANIMATION_NAME)
	rich_text_label.text = ""

func _input(event: InputEvent) -> void:
	
	if event.is_pressed() and intro.is_playing():
		intro.play_section_with_markers(ANIMATION_NAME,markers[scene_timelap])
		print(scene_timelap)
		$Skip.show()
	elif event.is_pressed() and not intro.is_playing():
		intro.play()
		$Skip.hide()
		
	
		
	
func increment_scene_timelap_count():
	scene_timelap += 1 

 

	
	
func _on_intro_animation_finished(anim_name: StringName) -> void:
	
	if anim_name == "Intro":
		get_tree().change_scene_to_file("res://Data/Levels/level_tutorial.tscn")
	pass # Replace with function body.
