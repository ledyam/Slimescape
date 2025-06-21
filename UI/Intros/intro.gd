extends VideoStreamPlayer



func _ready() -> void:
	self.play()
	await self.finished
	get_tree().change_scene_to_file("res://UI/Menu Principal/principal_menu.tscn")
