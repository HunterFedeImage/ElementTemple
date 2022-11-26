extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(60,0)


func _process(delta):
	self.translate(velocity * delta) # changing node's position
