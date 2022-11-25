extends Control




func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/Level1.tscn")


func _on_Salir_pressed():
	get_tree().Quit()
