extends StaticBody2D
class_name Door
@export var texture : Texture


func _ready() -> void:
	$DoorTexture.texture = texture
	$AnimationPlayer.play('default')


func open_door():
		$AnimationPlayer.play("Open")
		$DoorTexture.texture = null
