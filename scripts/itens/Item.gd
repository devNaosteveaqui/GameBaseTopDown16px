extends Sprite2D

class_name Item

signal ranout(item)

@export var timerCollect : Timer
@export var collisionArea : Area2D

var type
var nome : String
var slotEquipable : Array = []

var status : Status
var inventory : Array = []
var placeableRel : Dictionary
var storaged : int  = 1
var lastEntityCollect

var collectable : bool = false
var isBouncing : bool = false
var posSpawn : Vector2
var velocity_y = -300
var velocity_x = 3
var gravity_y = 800
var gravity_x = 1

static func create_item(itemType):
	var item = load("res://scenes/itens/Item.tscn").instantiate()
	item.nome = itemType.nome
	item.set_type(itemType)
	item.set_sprite(itemType.sprite)
	ItemInterface.set_slot_equipable(item,itemType.equipable)
	ItemInterface.set_inventory_slot(item,itemType.inventory_slots)
	item.initStatus()
	return item

func initStatus():
	status = Status.create_status(type)
	status.connect("statusIsZero",itemBreak)

func set_sprite(sprite):
	texture = load("res://resources/itens/" + sprite)

func set_type(itemType):
	type = itemType

func set_collectable(flag):
	collectable = flag

func _on_area_2d_body_entered(body):
	if ItemInterface.collect_item(self,body):
		self.queue_free()

func try_apply_effect(effect):
	StatusInterface.applyEffect({},effect,status)

func use_on(statistic,target,statsEffect:Array = [0,0,0,0]):
	var effectFinal = ItemInterface.get_effect_final(self.status,statsEffect)
	SystemBattle.apply_effect_on(statistic,effectFinal,target)
	if ItemInterface.is_consumable(self.type):
		itemBreak()

func itemBreak():
	ItemInterface.decumulate(self)
	if ItemInterface.is_storage_zero(self):
		emit_signal("ranout",self)

func dropContent():
	var drop = inventory.duplicate(true)
	drop.append_array(ItemInterface.get_drop(type))
	return drop

func _drop_on_ground(pos_spawn):
	self.posSpawn = pos_spawn
	self.position = pos_spawn
	velocity_x = velocity_x*(randi()%3 - 1)

func _on_tree_entered():
	isBouncing = true
	collectable = false

func _on_tree_exited():
	isBouncing = false

func _physics_process(delta):
	if isBouncing:
		position.y += velocity_y*delta
		position.x += velocity_x*delta
		
		velocity_y += gravity_y*delta
		velocity_x += gravity_x*delta
		
		if abs(posSpawn.y - position.y) < 4:
			velocity_y = -velocity_y*0.6
			if abs(velocity_y) < 50:
				isBouncing = false
				set_collectable(true)
