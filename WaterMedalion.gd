extends Node2D

var lifeToHeal = 10


func _on_Area2D_area_entered(area):
	print("colisiono")
	queue_free()
	pass # Replace with function body.
