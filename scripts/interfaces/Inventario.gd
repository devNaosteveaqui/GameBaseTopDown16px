extends Control

@export var gridInventory : ItemList
@export var gridEquipamentos : ItemList
@export var craft : Control 
@export var buttonWorkStation : ColorRect
@export var itemInfo : RichTextLabel
@export var windowEquipOnSlot : Control

const SIGNAL_IVENTORY_UPDATE = "inventoryUpdated"
const EMPTY_SLOT_LABEL = "vazio"
const NODE_NAME_RESULT = "Result"
const NODE_OPTION_SLOT_EQUIP = "Content/OptionSlotEquip"

var Work_Interfaces_Labels = ["Craft","Equipamentos"]
var mouseIsOn : bool = false
var canCraft : bool = false
var nCrafts : int = 0
var itemSelectedToEquip : int
var solotSelectedToEquip : int
var player

func showInventory(inventory):
	self.player = inventory
	self.player.connect(SIGNAL_IVENTORY_UPDATE,loadInventory)
	loadInventory()

func showItensOnInvetory(itens:Array):
	for slot in itens.size():
		if itens[slot] != null:
			gridInventory.add_item(ItemInterface.get_item_nome(itens[slot]),ItemInterface.get_texture(itens[slot].type))
		else:
			gridInventory.add_item(EMPTY_SLOT_LABEL)

func showItensEquiped(itens:Array):
	for slot in itens.size():
		if itens[slot] != null:
			gridEquipamentos.add_item(ItemInterface.get_item_nome(itens[slot]),itens[slot].texture)
		else:
			#gridEquipamentos.add_item("vazio")
			var texture : String = Inventory.EMPTY_SLOT_PLACEHOLDER[slot]
			gridEquipamentos.add_item(EMPTY_SLOT_LABEL,load(texture))

func showCraftItens():
	for idx in RCraft.RELATIONS.size():
		var recipe = RCraft.get_recipe_result(idx)
		craft.get_node(NODE_NAME_RESULT).add_item(recipe[recipe.keys()[0]].nome)
		craft.get_node(NODE_NAME_RESULT).select(-1)

func _on_inventory_item_activated(index):
	if gridEquipamentos.is_visible_in_tree():
		loadInventoryOptionsSlot()
		windowEquipOnSlot.show()
		itemSelectedToEquip = index
		#player.equipItem(index)

@warning_ignore("unused_parameter")
func _on_inventory_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index == 1:
		showItemInfo(player.get_item_inventory_info(index))
	elif mouse_button_index == 2:
		player.dropItemStoraged(index)

func _on_equipamentos_item_activated(index):
	player.unequipItem(index)

@warning_ignore("unused_parameter")
func _on_equipamentos_item_clicked(index, at_position, mouse_button_index):
	if mouse_button_index == 1:
		showItemInfo(player.get_item_equiped_info(index))
	elif mouse_button_index == 2:
		player.dropItemEquiped(index)


func _on_craft_action_button_down():
	var craftId = craft.get_node(NODE_NAME_RESULT).get_selected_id()
	if craftId > -1 && canCraft:
		var recipe = RCraft.get_recipe_result(craftId)
		var recipeKey = recipe.keys()[0]
		var item_type = recipe[recipeKey]
		var itemCrafted = ItemInterface.create_data_from_type(item_type,player)
		ItemInterface.set_quantity(itemCrafted,int(recipeKey.rsplit("x",true,1)[1]))
		if player.store_item(itemCrafted,Estatisticas.ITENS.CRAFTADOS):
			canCraft = false
			nCrafts -= 1
			var materials = RCraft.get_recipe_materials(craftId)
			for idx in materials.size():
				player.consumItem(materials[idx][1],int(materials[idx][0]))

func _on_result_item_selected(index):
	var result = RCraft.get_recipe_result(index)
	var rkey = result.keys()[0]
	var craftInfo : String = result[rkey].nome + " ( x" +rkey.rsplit("x",true,1)[1]+ " ) \n"
	craftInfo += result[rkey].desc + "\n"
	
	var materials = RCraft.get_recipe_materials(index) # [qtd : int , itemType],[...]...
	var hasMaterials = true
	var minProportion : int = 0
	
	for idx in materials.size():
		var qtdInventory : int = player.get_quantity_this_item(materials[idx][1])
		var qtdCraft : int = int(materials[idx][0])
		
		hasMaterials = hasMaterials && player.has_this_item_quantity(materials[idx][1],qtdCraft)
		
		craftInfo += str(qtdInventory) + " / " + str(qtdCraft) + " - " + materials[idx][1].nome + "\n"
		
		if qtdInventory > 0:
			@warning_ignore("integer_division")
			if minProportion > qtdCraft/qtdInventory:
				@warning_ignore("integer_division")
				minProportion = qtdCraft/qtdInventory
	
	canCraft = hasMaterials
	if !canCraft:
		minProportion = 0
	
	nCrafts = minProportion
	showItemInfo(craftInfo)

func loadInventory():
	clearInterface()
	showItensOnInvetory(player.inventory)
	showItensEquiped(player.equiped)
	showCraftItens()

func loadInventoryOptionsSlot():
	windowEquipOnSlot.get_node(NODE_OPTION_SLOT_EQUIP).clear()
	for slot in player.equiped.size():
		if player.equiped[slot] != null:
			windowEquipOnSlot.get_node(NODE_OPTION_SLOT_EQUIP).add_icon_item(player.equiped[slot].texture,ItemInterface.get_item_nome(player.equiped[slot]))
		else:
			var texture : String = Inventory.EMPTY_SLOT_PLACEHOLDER[slot]
			windowEquipOnSlot.get_node(NODE_OPTION_SLOT_EQUIP).add_icon_item(load(texture),EMPTY_SLOT_LABEL)

func _on_color_rect_mouse_entered():
	mouseIsOn = true
	buttonWorkStation.get_node("Hover").show()

func _on_color_rect_mouse_exited():
	mouseIsOn = false
	buttonWorkStation.get_node("Hover").hide()

func _on_color_rect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			buttonWorkStation.get_node("Clicked").show()
			if craft.is_visible_in_tree():
				buttonWorkStation.get_node("Label").text = Work_Interfaces_Labels[1]
				craft.hide()
				gridEquipamentos.show()
			elif gridEquipamentos.is_visible_in_tree():
				buttonWorkStation.get_node("Label").text = Work_Interfaces_Labels[0]
				gridEquipamentos.hide()
				craft.show()
		else:
			buttonWorkStation.get_node("Clicked").hide()

func showItemInfo(itemInfoText):
	itemInfo.text = itemInfoText

func _on_visibility_changed():
	if is_visible_in_tree():
		showCraftItens()
	else:
		clearInterface()

func clearInterface():
	itemInfo.text = ""
	gridEquipamentos.clear()
	gridInventory.clear()
	craft.get_node(NODE_NAME_RESULT).select(-1)
	craft.get_node(NODE_NAME_RESULT).clear()

func _on_close_button_button_up():
	GameConfig.call_inventory(null)


func _on_equipar_button_up() -> void:
	player.equipItemAt(itemSelectedToEquip,solotSelectedToEquip)
	windowEquipOnSlot.hide()


func _on_cancelar_button_up() -> void:
	windowEquipOnSlot.hide()


func _on_option_slot_equip_item_selected(index: int) -> void:
	solotSelectedToEquip = index
