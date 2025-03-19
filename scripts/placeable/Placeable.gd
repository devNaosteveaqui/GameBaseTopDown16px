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
	placeable.set_shape(placeableType.shape)
	placeable.set_animation(placeableType.animation)
	placeable.set_stage_max(placeableType.stage_max)
	placeable.initStatus()
	return placeable

func initStatus():
	inventory.resize(type.inventory_slots)
	status = Status.createStatus(inventory,type)
	status.connect("lifeIsZero",downStage)
	# A cada hit, mais próximo do próximo stage
	status.connect("lifeChange",update_lifebar)
	status.connect("lifeIsFull",recovery)

func set_stage_max(stg):
	stageMax = stg

func set_animation(spriteRef):
	if spriteRef != "":
		sprite.sprite_frames = load("res://resources/placeable/animation" + spriteRef)
		if sprite.sprite_frames.get_animation_names().has("stage_0"):
			sprite.play("stage_0")
		else:
			sprite.play("default")

func set_shape(shapeRef):
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
		status.set_status(type.born_status*stage)

#func try_apply_effect(statistic,effect):
	#status.applyEffect(statistic,effect)

func hasDefense():
	return status.get_defense()[0] > 0

func canStoreItens():
	return inventory.size() > 0

func get_reduction_effect_by_item_hardness(item):
	var effect_reduction : float = 1
	var selfHardness = RUseable.findRelation(type).on_item
	var itemHardness = RUseable.findRelation(item.type).on_placeable
	
	var rdif = selfHardness - itemHardness
	
	if rdif > 0:
		item.try_apply_effect([-1 + (-1)*(rdif/2),0,0,0])
	else:
		effect_reduction = 0
		item.try_apply_effect([-1,0,0,0])
	return effect_reduction

func get_status_class():
	return status

func downStage():
	if sprite.sprite_frames.get_animation_names().size() > 1:
		if stage != 1:
			changeStage(1)
			dropm_item_by_random(1)
			if hasRegen:
				$Timer.start(5)
				$Timer.connect("timeout",status.activeRegen)
		else:
			breakStruct()
	else:
		breakStruct()

func breakStruct():
	drop_all()
	queue_free()
	#get_parent().remove_child(self)

func drop_all():
	for d in itemDrop:
		drop_item(d)

func dropm_item_by_random(qtd:int=-1):
	var idx = randi()%itemDrop.size()
	drop_item_by_id(idx,qtd)

func drop_item_by_stage():
	
	pass

func drop_item_by_id(idx,qtd:int=-1):
	drop_item(itemDrop[idx],qtd)
	itemDrop[idx][0] = itemDrop[idx][0] - qtd

func drop_item(item_cfg,qtd:int=-1):
	var item : Item = Item.createItem(item_cfg[1])
	if qtd == -1:
		item.set_quantity(item_cfg[0])
	else:
		item.set_quantity(qtd)
	item.dropOnGround(position)
	get_parent().add_child(item)
