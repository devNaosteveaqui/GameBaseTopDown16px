extends Control

@export var gridInventory : ItemList
@export var gridEquipamentos : ItemList
@export var craft : Control 
@export var buttonWorkStation : ColorRect
@export var itemInfo : RichTextLabel
@export var windowEquipOnSlot : Control

var WorkInterfaces = ["Craft","Equipamentos"]
var mouseIsOn : bool = false
var canCraft : bool = false
var nCrafts : int = 0
var itemSelectedToEquip : int
var solotSelectedToEquip : int
var player

func showInventory(inventory):
	self.player = inventory
	self.player.connect("inventoryUpdated",loadInventory)
	loadInventory()

func showItensOnInvetory(itens:Array):
	for slot in itens.size():
		if itens[slot] != null:
			gridInventory.add_item(itens[slot].get_item_nome(),itens[slot].texture)
		else:
			gridInventory.add_item("vazio")

func showItensEquiped(itens:Array):
	for slot in itens.size():
		if itens[slot] != null:
			gridEquipamentos.add_item(itens[slot].get_item_nome(),itens[slot].texture)
		else:
			#gridEquipamentos.add_item("vazio")
			var texture : String = "res://resources/interface/"
			match slot:
				Inventory.HEAD:
					texture = texture + "head_slot_symbol.png"
				Inventory.TORSO:
					texture = texture + "chest_slot_symbol.png"
				Inventory.PERNAS:
					texture = texture + "leg_slot_symbol.png"
				Inventory.PES:
					texture = texture + "foot_slot_symbol.png"
				Inventory.HAND_L,Inventory.HAND_R:
					texture = texture + "hold_slot_symbol.png"
				_:
					texture = texture + "finger_slot_symbol.png"
			gridEquipamentos.add_item("vazio",load(texture))

func showCraftItens():
	for idx in RCraft.RELATIONS.size():
		var recipe = RCraft.get_recipe_result(idx)
		craft.get_node("Result").add_item(recipe[recipe.keys()[0]].nome)
		craft.get_node("Result").select(-1)

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
	var craftId = craft.get_node("Result").get_selected_id()
	if craftId > -1 && canCraft:
		var recipe = RCraft.get_recipe_result(craftId)
		var recipeKey = recipe.keys()[0]
		var item_type = recipe[recipeKey]
		var itemCrafted = Item.create_item(item_type)
		itemCrafted.set_quantity(int(recipeKey.rsplit("x",true,1)[1]))
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
		
		hasMaterials = hasMaterials && player.hasThisItemQuantity(materials[idx][1],qtdCraft)
		
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
	windowEquipOnSlot.get_node("Content/OptionSlotEquip").clear()
	for slot in player.equiped.size():
		if player.equiped[slot] != null:
			windowEquipOnSlot.get_node("Content/OptionSlotEquip").add_icon_item(player.equiped[slot].texture,player.equiped[slot].get_item_nome())
		else:
			var texture : String = "res://resources/interface/"
			match slot:
				Inventory.HEAD:
					texture = texture + "head_slot_symbol.png"
				Inventory.TORSO:
					texture = texture + "chest_slot_symbol.png"
				Inventory.PERNAS:
					texture = texture + "leg_slot_symbol.png"
				Inventory.PES:
					texture = texture + "foot_slot_symbol.png"
				Inventory.HAND_L,Inventory.HAND_R:
					texture = texture + "hold_slot_symbol.png"
				_:
					texture = texture + "finger_slot_symbol.png"
			windowEquipOnSlot.get_node("Content/OptionSlotEquip").add_icon_item(load(texture),"vazio")

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
				buttonWorkStation.get_node("Label").text = WorkInterfaces[1]
				craft.hide()
				gridEquipamentos.show()
			elif gridEquipamentos.is_visible_in_tree():
				buttonWorkStation.get_node("Label").text = WorkInterfaces[0]
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
	craft.get_node("Result").select(-1)
	craft.get_node("Result").clear()

func _on_close_button_button_up():
	self.hide()


func _on_equipar_button_up() -> void:
	player.equipItemAt(itemSelectedToEquip,solotSelectedToEquip)
	windowEquipOnSlot.hide()


func _on_cancelar_button_up() -> void:
	windowEquipOnSlot.hide()


func _on_option_slot_equip_item_selected(index: int) -> void:
	solotSelectedToEquip = index
