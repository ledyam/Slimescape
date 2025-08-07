extends Resource
class_name Buff

enum Type {DOUBLE_JUMP , CHANGE_GRAVITY,MORE_VELOCITY}

@export var animated_sprite : SpriteFrames
@export var sound : AudioStreamWAV
@export var type : Type
