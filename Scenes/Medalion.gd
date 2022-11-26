extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_Area2D_area_entered(area):
	print("colisiono")
	if(area.name == "PlayerArea"):
		queue_free()

