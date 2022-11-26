extends KinematicBody2D

const moveSpeed = 50
const maxSpeed = 100

var jumpHeight = -350

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
var fireball = preload ("res://Scenes/Fireball.tscn")
var time_start = 0
var time_fire = 0


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
	
		var time_elapsed = OS.get_ticks_msec ( ) - time_fire
		if Input.is_action_just_pressed("attack") and time_elapsed >= 800:
			time_fire = OS.get_ticks_msec ( )
			get_node("AnimationPlayer").play("Attack")
			fire()


func _on_Area2D_area_entered(area):
	print("personaje colisiono con " + area.name)
	print(area.get_groups())
	if area.name == "WallArea":
		print("wall area touch")
		get_tree().reload_current_scene()
		
	if area.is_in_group("EnemyArea"):
		life = life - (enemyDamage - defense)
		get_node("UI/hp").text = "HP: " + str(life)
		if(life<=0):
			get_node("AnimationPlayer").play("Death")
			get_tree().reload_current_scene()
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
	
func fire ():
	var fireball_instance = fireball.instance()
	fireball_instance.position = get_global_position()
	if(sprite.flip_h == true):
		fireball_instance.direction = -1
	else:
		fireball_instance.direction = 1
	get_tree().get_root().call_deferred("add_child",fireball_instance)
