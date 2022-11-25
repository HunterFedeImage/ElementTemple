extends KinematicBody2D

const moveSpeed = 25
const maxSpeed = 50

var jumpHeight = -300

const up = Vector2(0,-1)
var gravity = 15

var motion = Vector2()
var life = 100
var maxLife = 100
var defense = 0
var enemyDamage = 50

onready var sprite = $Sprite
var _defenseTimer = null
var _jumpPoweupTimer = null

func _ready():
	add_defense_powerup_timer()
	add_jump_powerup_timer()


func _physics_process(delta):
#	print(str(gravity))
	motion.y += gravity 
	var friction = false
	if(life >0 ):
		if Input.is_action_pressed("ui_right"):
			sprite.flip_h = false
			get_node("AnimationPlayer").play("MoveRight")
			motion.x = min(motion.x + moveSpeed,maxSpeed)
		
		elif Input.is_action_pressed("ui_left"):
			sprite.flip_h = true

			motion.x = max(motion.x - moveSpeed,-maxSpeed)
		elif Input.is_key_pressed(KEY_A):
			get_node("AnimationPlayer").play("Attack")
		else: 
			friction = true
			get_node("AnimationPlayer").play("Idle")
			
		if is_on_floor():
			if Input.is_action_pressed("ui_accept"):
				motion.y = jumpHeight
				get_node("AnimationPlayer").play("Jump")
			if friction == true:
				motion.x = lerp(motion.x ,0,0.5)
				get_node("AnimationPlayer").play("Idle")
		else:
			if friction == true:
				motion.x = lerp(motion.x,0,0.01)
				get_node("AnimationPlayer").play("Idle")
		
		motion = move_and_slide(motion,up)


func _on_Area2D_area_entered(area):
	print("personaje colisiono con " + area.name)
	print(area.get_groups())
	if area.name == "WallArea":
		print("wall area touch")
#		queue_free()
	if area.is_in_group("EnemyArea"):
		print("Se choco con enemigo")
		life = life - (enemyDamage - defense)
		get_node("UI/hp").text = "HP: " + str(life)
		if(life<=0):
			print("murio")
			get_node("AnimationPlayer").play("Death")
	elif area.name == "WaterMedalionArea":
			if life+10 <= maxLife:
				life += 10
				get_node("UI/hp").text = "HP: " + str(life)
	elif area.name == "EarthMedalionArea":
		print("tierra")
		increase_defense_momentarily()
	elif area.name == "WindMedalionArea":
		print("fede wind medalion")
		increase_jump_momentarily()
	print("vida " + str(life))
	print("defensa " + str(defense))
	print("jumpHeight " + str(gravity))
	
func increase_defense_momentarily():
	defense += 10
	_defenseTimer.start()
	
func increase_jump_momentarily():
	print("bajo la gravedad")
	jumpHeight -= 100
	_jumpPoweupTimer.start()
	
func _on_defense_Timer_timeout():
	defense -=5
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
	gravity += 5
