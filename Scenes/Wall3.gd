extends Node2D


var velocity = Vector2(70,0)


func _process(delta):
	self.translate(velocity * delta) # changing node's position
