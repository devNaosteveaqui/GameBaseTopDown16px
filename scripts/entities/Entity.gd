extends CharacterBody2D

class_name Entity

@export var sprite : AnimatedSprite2D
@export var raycast : RayCast2D
@export var lifebar : ColorRect
@export var inventory : Node

var direction_angle = 0
var range_action = 24

var inMoviment = 0
var hitted = false
var hitting = false

var status = [20,5,5,0]
var statusMax = [20,5,5,100]
var natural_regen = [1,1,1,0]
var regen_ativated = true

static func create_entity(race):
	var e = load("res://REMAKE/scenes/entities/Entity.tscn").instantiate()
	e.setRace(race)
	return e

func setRace(race):
	setAnimation(race.animation)

func setAnimation(animation):
	sprite.sprite_frames = load("res://REMAKE/resources/entities/"+animation)
	sprite.play("default")

func _ready():
	raycast.target_position = Vector2(0,range_action)
	$Timer.start(5)
	$Timer.connect("timeout",updateEntity)

func _process(delta):
	updateDirection()
	updateVelocity()
	updateAnimation()
	move_and_slide()

# FUNCIONS ON AUTOMATIC

func updateVelocity():
	self.velocity = (50*raycast.target_position/range_action)*inMoviment

func updateAnimation():
	if hitting:
		sprite.play("hitting")
	elif hitted:
		sprite.play("hitted")
	elif inMoviment == 1:
		sprite.play("walk")
	else:
		sprite.play("default")

func updateDirection():
	var direction = raycast.target_position
	raycast.target_position = direction.rotated(deg_to_rad(direction_angle))

func updateLifebar():
	lifebar.size.x = 20.0*(status[0]/statusMax[0])

func naturalRegen():
	gainStatus(0,natural_regen[0])
	gainStatus(1,natural_regen[1])
	gainStatus(2,natural_regen[2])
	gainStatus(3,natural_regen[3])

func updateEntity():
	if regen_ativated:
		naturalRegen()

func _on_animation_looped():
	if sprite.animation == "hitted":
		hitted = false
	if sprite.animation == "hitting":
		hitting = false

# FUNCTIONS ON POS ACTION

func hit():
	hitted = true
	inMoviment = 0

# FUNCTIONS ON ACTION

func lossStatus(sts,value):
	if status[sts] - value < 0:
		status[sts] = 0
	else:
		status[sts] -= value
	updateLifebar()
	hit()

func gainStatus(sts,value):
	if status[sts] + value > statusMax[sts]:
		status[sts] = statusMax[sts]
	else:
		status[sts] += value
	updateLifebar()
	hit()

func walk_to(target:Vector2):
	if target.is_equal_approx(Vector2.ZERO):
		inMoviment = 0
	else:
		inMoviment = 1
	look_to(target*range_action)

func active_action():
	hitting = true
	inMoviment = 0

func look_to(target : Vector2):
	direction_angle = get_angle_to(target)

func collect(item):
	var isFull = inventory.store_item(item)
	if isFull:
		drop(item)

func drop(item):
	item.position = position + raycast.target_position
	get_parent().add_child(item)

func dropAll(itens):
	for i in itens.size():
		drop(itens[i])
