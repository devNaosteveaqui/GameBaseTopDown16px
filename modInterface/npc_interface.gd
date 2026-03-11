extends Control

@export var list_container : GridContainer
@export var npcs_interface : Node
@export var itens_interface : Node

const NPC_INTERFACE_HEADS = ["Sprite","Nome","Energias\n(V , F , M , E)","Dano a Energia\n(V , F , M , E)", "Drops"]
const ITEM_INTERFACE_HEADS = ["Sprite","Nome"]

var interfaces : Dictionary = {
	"npcs_list" : call_npc_interface,
	'item_list' : call_item_interface
}

var list : Array = []


func _ready() -> void:
	interfaces["item_list"].call()
	show_list()

func call_item_interface():
	set_head(ITEM_INTERFACE_HEADS)
	list = itens_interface.create_list()

func call_npc_interface():
	set_head(NPC_INTERFACE_HEADS)
	list = npcs_interface.create_list()

func set_head(heads:Array):
	list_container.columns = heads.size()
	var head : Label
	for h in heads:
		head = Label.new()
		head.text = h
		head.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		head.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		list_container.add_child(head)

#func add_item(entitie):
	#
	#var item_list : Dictionary = {
		#'sprite' : entitie.animation,
		#'nome' : entitie.nome,
		#"energias":entitie.born_status,
		#"dano a energia":entitie.born_effect,
		#"drops":create_drop_list(RDrop.findRelation(entitie).drop_p)
	#}
	#
	#list.append(item_list)

func show_list():
	for i in list:
		var label_item : Label
		for s in i:
			if i[s] is SpriteFrames:
				var texture_container : CenterContainer = CenterContainer.new()
				var texture_control : Control = Control.new()
				var texture_sprite : AnimatedSprite2D = AnimatedSprite2D.new()
				texture_sprite.sprite_frames = i.sprite
				texture_sprite.play("default")
				texture_control.set_anchors_preset(Control.PRESET_CENTER)
				texture_control.add_child(texture_sprite)
				texture_container.add_child(texture_control)
				list_container.add_child(texture_container)
			elif i[s] is String:
				if i[s].find("res://") != -1:
					list_container.add_child(create_sprite(i[s]))
				else:
					label_item = Label.new()
					label_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
					label_item.text = str(i[s])
					list_container.add_child(label_item)
			elif i[s] is int:
				label_item = Label.new()
				label_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				label_item.text = str(i[s])
				list_container.add_child(label_item)
			elif i[s] is Array:
				if i[s][0] is String :
					if i[s][0].find("res://") != -1:
						list_container.add_child(add_list_of_images(i.drops))
					else:
						label_item = add_multiple_value(i[s])
						label_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
						list_container.add_child(label_item)
				elif i[s][0] is int:
					label_item = add_multiple_value(i[s])
					label_item.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
					list_container.add_child(label_item)
				#elif i[s][0] is Array:
					#list_container.add_child(add_list_of_images(i.drops))

func add_multiple_value(list:Array):
	var data_info : Label = Label.new()
	for i in list.size():
		data_info.text += str(list[i])
		if list.size()-1 != i:
			data_info.text += " , "
	return data_info

func add_list_of_images(list:Array):
	var drop_sprite : TextureRect
	var box : HBoxContainer = HBoxContainer.new()
	for i in list:
		drop_sprite = TextureRect.new()
		drop_sprite.texture = load(i)
		drop_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		box.add_child(drop_sprite)
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return box

func create_sprite(img_res):
	var sprite : TextureRect = TextureRect.new()
	sprite.texture = load(img_res)
	sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	return sprite
	
#func create_drop_list(list):
	#var new_list : Array = []
	#for i in list:
		#new_list.append("res://resources/itens/" + i[1].sprite)
	#return new_list
