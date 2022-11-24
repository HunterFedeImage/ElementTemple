extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var velocity = Vector2(10,0)
var speed = 10
var direction = 1
var _timer = null
var gravity = 15


func _ready():
	get_node("Animations").play("MoveRight")
	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(5.0)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()


func _on_Timer_timeout():
	_change_direction()
	_change_animation()
	print("Second!")

func _change_animation():
	if (get_node("Animations").get_current_animation() == "MoveRight"):
		get_node("Animations").play("MoveLeft")
	else: 
		get_node("Animations").play("MoveRight")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _change_direction():
	direction = direction * -1
	velocity = Vector2(speed * direction,0) 

func _physics_process(delta):
	velocity.y += gravity
	velocity = move_and_slide(velocity)


func _on_EnemyArea_area_entered(area):
	if "FireBallArea" in area.name:
		queue_free()

