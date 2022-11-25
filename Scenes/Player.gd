extends KinematicBody2D

const moveSpeed = 25
const maxSpeed = 50

var jumpHeight = -300

const up = Vector2(0,-1)
const gravity = 15

var motion = Vector2()
var life = 100
var defense = 0
var enemyDamage = 50

onready var sprite = $Sprite
var _defenseTimer = null
var _jumpPoweupTimer = null

func _ready():
	add_defense_powerup_timer()
	add_jump_powerup_timer()


func _physics_process(delta):
	motion.y += gravity 
	var friction = false
	
	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = true
		motion.x = min(motion.x + moveSpeed,maxSpeed)
	
	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = false
		motion.x = max(motion.x - moveSpeed,-maxSpeed)
	else: 
		friction = true
		
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			motion.y = jumpHeight
		if friction == true:
			motion.x = lerp(motion.x ,0,0.5)
	else:
		if friction == true:
			motion.x = lerp(motion.x,0,0.01)
	
	motion = move_and_slide(motion,up)


func _on_Area2D_area_entered(area):
	print("personaje colisiono con " + area.name)
	print(area.get_groups())
	if area.name == "WallArea":
		print("wall area touch")
#		queue_free()
	if area.is_in_group("EnemyArea"):
		life = life - (enemyDamage - defense)
		get_node("UI/hp").text = "HP: " + str(life)
	elif area.name == "WaterMedalionArea":
			life += 10
			get_node("UI/hp").text = "HP: " + str(life)
	elif area.name == "EarthMedalionArea":
		print("tierra")
		increase_defense_momentarily()
	print("vida" + str(life))
	print("defensa" + str(defense))
	
func increase_defense_momentarily():
	defense += 10
	_defenseTimer.start()
	
func increase_jump_momentarily():
	jumpHeight -= 100
	_defenseTimer.start()
	
func _on_defense_Timer_timeout():
	defense -=10
	print(defense)
	
func add_defense_powerup_timer():
	_defenseTimer = Timer.new()
	add_child(_defenseTimer)
	_defenseTimer.connect("timeout", self, "_on_defense_Timer_timeout")
	_defenseTimer.set_one_shot(true)
	_defenseTimer.set_wait_time(5.0)
	
func add_jump_powerup_timer():
	_jumpPoweupTimer = Timer.new()
	add_child(_jumpPoweupTimer)
	_jumpPoweupTimer.connect("timeout", self, "_on_jump_Timer_timeout")
	_jumpPoweupTimer.set_one_shot(true)
	_jumpPoweupTimer.set_wait_time(5.0)

func _on_jump_Timer_timeout():
	jumpHeight+=100
