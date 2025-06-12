extends StaticBody2D

@export var texture : Texture
@export_enum("RED","BLUE") var color : int 


func _ready() -> void:
	CentralSignal.open_door.connect(on_open_door)
	$DoorTexture.texture = texture


func on_open_door(signal_color : int ):
	
	if signal_color == color:
		$AnimationPlayer.play("Open")
		$DoorTexture.texture = null
