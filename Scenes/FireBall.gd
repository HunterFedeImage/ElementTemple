extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(30,0)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PlayerDetector_body_entered(body):
	print("Entro")
	pass

func _physics_process(delta):
	velocity = move_and_slide(velocity)


func _on_FireBallArea_area_entered(area):
	queue_free()
	pass # Replace with function body.