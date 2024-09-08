extends StaticBody2D

class_name Placeable

@export var sprite : AnimatedSprite2D
@export var shape : CollisionShape2D

var stage = 0
var stageMax = 1
var hasRegen : bool = false
var status : Status
var itemDrop
var inventory : Array = []
var type

static func createPlaceable(placeableType):
	var placeable = load("res://scenes/placeable/Placeable.tscn").instantiate()
	placeable.itemDrop = RDrop.findRelation(placeableType)
	placeable.type = placeableType
	placeable.setShape(placeableType.shape)
	placeable.setAnimation(placeableType.animation)
	placeable.setStageMax(placeableType.stage_max)
	placeable.initStatus()
	return placeable

func initStatus():
	inventory.resize(type.inventory_slots)
	status = Status.createStatus(inventory,type)
	status.connect("lifeIsZero",downStage)
	status.connect("lifeIsFull",recovery)

func setStageMax(stg):
	stageMax = stg

func setAnimation(spriteRef):
	if spriteRef != "":
		sprite.sprite_frames = load("res://resources/placeable/animation" + spriteRef)
		sprite.play("stage_0")

func setShape(shapeRef):
	if shapeRef != "":
		shape.shape=load("res://resources/placeable/shape" + shapeRef)

func changeStage(next):
	stage = next
	sprite.play("stage_"+str(stage))

func recovery():
	if stage == stageMax:
		changeStage(0)
		sprite.play("stage_"+str(stage))
		$Timer.stop()
	else:
		changeStage(stage+1)
		status.setStatus(type.born_status*stage)

func tryApplyEffect(effect):
	status.applyEffect(effect)

func hasDefense():
	return status.getDefense()[0] > 0

func canStoreItens():
	return inventory.size() > 0

func testHardnessItem(item):
	var effect_passed : bool = true
	var selfHardness = RUseable.findRelation(type).on_item
	var itemHardness = RUseable.findRelation(item.type).on_placeable
	
	var rdif = selfHardness - itemHardness
	
	if rdif > 0:
		effect_passed = false
		item.tryApplyEffect([-1 + (-1)*(rdif/2),0,0,0])
	else:
		item.tryApplyEffect([-1,0,0,0])
	return effect_passed

func downStage():
	if sprite.sprite_frames.get_animation_names().size() > 1:
		if stage != 1:
			changeStage(1)
			drop()
			if hasRegen:
				$Timer.start(5)
				$Timer.connect("timeout",status.activeRegen)
		else:
			breakStruct()
	else:
		breakStruct()

func breakStruct():
	drop()
	queue_free()
	#get_parent().remove_child(self)

func drop():
	for d in itemDrop:
		var item : Item = Item.createItem(d[1])
		item.setQuantity(d[0])
		item.dropOnGround(position)
		
		get_parent().add_child(item)
