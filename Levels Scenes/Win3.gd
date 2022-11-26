extends Area2D




func _on_Win3_body_entered(body):
	if body.get_name() == "Player":
		print("Hemos ganado")
		get_tree().change_scene("res://Scenes/Menu.tscn")
