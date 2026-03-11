extends StaticBody2D

class_name Placeable

@export var target_efect : AnimationPlayer
@export var sprite : AnimatedSprite2D
@export var shape : CollisionShape2D
@export var body_area : Area2D

var stage = 0
var stageMax = 1
var hasRegen : bool = false
var status : Status
var itemDrop
var qtdByDrop : int = 1
var itemDropByHit
var qtdByHit : int = 1
var inventory : Array = []
var type
var hitted_by

static func create_placeable(placeableType):
	var placeable = Placeables.OBJECT_PLACEABLE.instantiate()
	var drops = RDrop.findRelation(placeableType)
	#if drops == null:
		#return null
	if drops != null:
		placeable.itemDrop = drops.drop_p
		placeable.itemDropByHit = drops.drop_s
	placeable.type = placeableType
	placeable.set_shape(placeableType.shape)
	placeable.set_animation(placeableType.animation)
	placeable.set_stage_max(placeableType.stage_max)
	placeable.initStatus()
	GameConfig.create_object(placeable)
	return placeable

func initStatus():
	add_to_group(GameConfig.GROUP_INTERACTABLE)
	inventory.resize(type.inventory_slots)
	status = Status.create_status(type)
	status.connect("statusIsZero",status_is_zero)
	# A cada hit, mais próximo do próximo stage
	#status.connect("statusChange",status_change) # FIX IT - Precisa bater porém não trocar de estado
	status.connect("statusIsFull",status_is_full)
	set_monitoring_collision_state(false)

func status_is_zero(sts):
	downStage()
func status_change(sts):
	pass #Antes chamava o hitted()
func status_is_full(sts):
	recovery()

func set_stage_max(stg):
	stageMax = stg

func set_animation(spriteRef):
	if spriteRef == null:
		return
	sprite.sprite_frames = spriteRef
	if sprite.sprite_frames.get_animation_names().has("stage_0"):
		sprite.play("stage_0")
	else:
		sprite.play("default")

func set_shape(shapeRef):
	if shapeRef != null:
		shape.shape = shapeRef
		#shape.shape=load("res://resources/placeable/shape" + shapeRef)
		body_area.get_child(0).shape = shapeRef
		#body_area.get_child(0).shape=load("res://resources/placeable/shape" + shapeRef)

func set_monitoring_collision_state(monitoring_state:bool):
	$CollisionShape2D.disabled = !monitoring_state
	$Area2D.get_child(0).disabled = !monitoring_state
	$Area2D.monitoring = monitoring_state
	$Area2D.monitorable = monitoring_state
	collision_layer = int(monitoring_state)
	collision_mask = int(monitoring_state)
	$Area2D.collision_layer = int(monitoring_state)
	$Area2D.collision_mask = int(monitoring_state)
	if monitoring_state:
		$Area2D.show()
	else:
		$Area2D.hide()
	
func set_position_on_world(x,y):
	self.position = Vector2(x,y)

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

func hasDefense():
	return StatusInterface.get_defense(status.general_status)[0] > 0

func canStoreItens():
	return inventory.size() > 0

func get_status_class():
	return status

func downStage():
	if sprite.sprite_frames.get_animation_names().size() > 1:
		if stage != 1:
			changeStage(1)
			drop_item_by_random(itemDrop,qtdByDrop)
			if hasRegen:
				$Timer.start(5)
				$Timer.connect("timeout",StatusInterface.apply_regen.bind(status))
			else:
				StatusInterface.fill_life(status)
		else:
			breakStruct()
	else:
		breakStruct()

func hitted():
	drop_item_by_hit()

func hitted_by_item(item_type_used):
	hitted_by = item_type_used
	hitted()

func targeted_effect_active():
	target_efect.play("Targeted")

func targeted_effect_deactive():
	target_efect.stop()

func breakStruct():
	drop_all()
	queue_free()
	#get_parent().remove_child(self)

func drop_all():
	for d in itemDrop:
		drop_item(d)

func drop_item_by_hit():
	if !itemDropByHit.flag_all and itemDropByHit.drop_hit != null:
		drop_item_by_random(itemDropByHit.drop_hit,qtdByHit)

func drop_item_by_random(source,qtd:int=-1):
	if source.size() > 0:
		var idx = randi()%source.size()
		drop_item_by_id(source,idx,qtd)

func drop_item_by_id(source:Array,idx,qtd:int=-1):
	drop_item(source[idx],qtd)
	source[idx][0] = source[idx][0] - qtd
	if source[idx][0] < 1:
		source.remove_at(idx)

func drop_item(item_cfg,qtd:int=-1):
	var item : Item = Item.create_item(item_cfg[1])
	if qtd == -1:
		ItemInterface.set_quantity(item,item_cfg[0])
	else:
		ItemInterface.set_quantity(item,qtd)
	item._drop_on_ground(position)
	get_parent().add_child(item)
