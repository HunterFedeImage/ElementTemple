extends Node2D

var velocity = Vector2(70,0)
var _disapearTimer = null

func _ready():
	disapear_timer_start()

func _process(delta):
	self.translate(velocity * delta) # changing node's position

func disapear_timer_start():
	_disapearTimer = Timer.new()
	add_child(_disapearTimer)
	_disapearTimer.connect("timeout", self, "_on_disapear_timeout")
	_disapearTimer.set_one_shot(true)
	_disapearTimer.set_wait_time(1.0)
	_disapearTimer.start()

func _on_disapear_timeout():
	queue_free()


func _on_FireBallArea_area_entered(area):
	if(area.is_in_group("EnemyArea")):
		queue_free()
