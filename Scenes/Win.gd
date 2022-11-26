extends Area2D



func _on_Win_body_entered(body):
	if body.get_name() == "Player":
		print("Hemos ganado")
		get_tree().change_scene("res://Levels Scenes/Level2.tscn")
