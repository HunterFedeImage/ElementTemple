extends Node2D

var speed = 80
var velocity = null
var _disapearTimer = null
var direction = 1

func _ready():
	velocity = Vector2(speed * direction,0)
	disapear_timer_start()

func _process(delta):
	self.translate(velocity * delta) # changing node's position

func disapear_timer_start():
	_disapearTimer = Timer.new()
	add_child(_disapearTimer)
	_disapearTimer.connect("timeout", self, "_on_disapear_timeout")
	_disapearTimer.set_one_shot(true)
	_disapearTimer.set_wait_time(2.0)
	_disapearTimer.start()

func _on_disapear_timeout():
	queue_free()


func _on_FireBallArea_area_entered(area):
	if(area.is_in_group("EnemyArea")):
		queue_free()
