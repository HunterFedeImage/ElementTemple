extends Area2D





func _on_Win2_body_entered(body):
	if body.get_name() == "Player":
		print("Hemos ganado")
		get_tree().change_scene("res://Levels Scenes/Level3.tscn")
