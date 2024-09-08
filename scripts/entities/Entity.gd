extends CharacterBody2D

class_name Entity

signal deathCharacter

@export var sprite : AnimatedSprite2D
@export var raycast : RayCast2D
@export var lifebar : ColorRect
@export var inventory : Node

var direction_angle = 0
var range_action = 24
var inMoviment = 0
var hitted = false
var hitting = false
var regen_ativated = true

var status : Status
var type


static func create_entity(race):
	var e : Entity= load("res://scenes/entities/Entity.tscn").instantiate()
	e.inventory.createInventory()
	e.setRace(race)
	var drops = RDrop.findRelation(race)
	if drops != null:
		for d in drops:
			var item : Item = Item.createItem(d[1])
			item.setQuantity(d[0])
			e.inventory.store_item(item)
	e.initStatus()
	return e

func initStatus():
	status = Status.createStatus(inventory,type)
	status.connect("lifeIsZero",death)
	status.connect("lifeLoss",hit)
	status.connect("lifeChange",updateLifebar)
	status.connect("lifeIsFull",stopRegen)

func setRace(race):
	setAnimation(race.animation)
	type = race

func setAnimation(animation):
	sprite.sprite_frames = load("res://resources/entities/"+animation)
	sprite.play("default")

func _ready():
	raycast.target_position = Vector2(0,range_action)

func _process(delta):
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

func updateLifebar():
	lifebar.size.x = 20.0*(status.getLifeState())

func stopRegen():
	if $Timer.time_left > 0:
		$Timer.stop()

func updateEntity():
	if regen_ativated:
		if $Timer.time_left == 0:
			$Timer.start(10)
			$Timer.connect("timeout",status.activeRegen)

func _on_animation_looped():
	if sprite.animation == "hitted":
		hitted = false
	if sprite.animation == "hitting":
		hitting = false

# FUNCTIONS ON POS ACTION

func hit():
	hitted = true
	inMoviment = 0
	updateEntity()

# FUNCTIONS ON ACTION

func walk_to(target:Vector2):
	if target.is_equal_approx(Vector2.ZERO):
		inMoviment = 0
	else:
		inMoviment = 1
		look_to(target*range_action)

func look_to(target : Vector2):
	raycast.target_position = target

func collect(item):
	var isStoraged = inventory.store_item(item)
	if !isStoraged:
		drop(item)

func drop(item):
	item.dropOnGround(position)
	get_parent().add_child(item)

func dropAll(itens):
	for i in itens.size():
		if itens[i] != null:
			drop(itens[i])

# ENTITY ACTIONS

func active_action():
	hitting = true
	inMoviment = 0

func useItem(onSelf:bool):
	var target = raycast.get_collider()
	if onSelf:
		target = self
	if !onSelf && target == null:
		inventory.placeItemOnWorld(get_parent())
	if target != null :
		if target is Entity || target is Placeable:
			makeActionOn(target)

func makeActionOn(target):
	status.consumStatus()
	var weapon = inventory.getPrincipalItem()
	
	if weapon == null:
		if target.hasDefense():
			tryApplyEffect([-1,0,0,0])
		else:
			target.tryApplyEffect(status.getEffect())
	else:
		if target.hasDefense():
			if target.testHardnessItem(weapon):
				weapon.useOn(target,status.getEffect())
		else:
			weapon.useOn(target,status.getEffect())

func tryApplyEffectOnArmor(effect):
	inventory.damageArmor(effect,Inventory.TORSO)

func testHardnessItem(item):
	var effectPassed = false
	var itemHardness = RUseable.findRelation(item.type).on_item
	var amorPieces = inventory.getHardenessAmorPieces()
	
	for piece in amorPieces.size():
		var rdif = piece - itemHardness
		if rdif >= 5:
			item.tryApplyEffect([-1 + (-1)*(rdif/2),0,0,0])
		elif rdif >= 0:
			effectPassed = true
			item.tryApplyEffect([-1,0,0,0])
			inventory.damageArmor([-1,0,0,0],piece)
		else:
			effectPassed = true
			inventory.damageArmor([-1 + (rdif/2),0,0,0],piece)
	return effectPassed

func tryApplyEffect(effect):
	status.applyEffect(effect)

func hasDefense():
	return inventory.getArmorDefense().size() > 0

func interact():
	var interactable = raycast.get_collider()
	if interactable.has_method("try_interact"):
		interactable.try_interact()

func try_interact():
	print("Interagindo")

func callSkill():
	#chama a skill da lista do conhecimento
	pass

func openInterface():
	var struct = raycast.get_collider()
	if struct != null:
		pass

func getPositionOnEye():
	return position + raycast.target_position

func death():
	dropAll(inventory.inventory)
	dropAll(inventory.equiped)
	emit_signal("deathCharacter")
	queue_free()
