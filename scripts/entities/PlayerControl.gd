extends Node2D

@onready var body : Entity = get_parent()

var inventoryUI : Control

func _process(delta):
	if Input.is_action_just_pressed("Interact"):
		body.interact()
	elif Input.is_action_just_pressed("Use"):
		body.useItem(false)
	elif Input.is_action_just_pressed("OpenInterface"):
		pass
	elif Input.is_action_just_pressed("CallSkill"):
		pass
	elif Input.is_action_just_pressed("OpenInventory"):
		if inventoryUI.is_visible_in_tree():
			inventoryUI.hide()
		else:
			inventoryUI.show()
			inventoryUI.showInventory(body.inventory)
	
func _physics_process(delta):
	var press = Vector2(Input.get_axis("ui_left","ui_right"),Input.get_axis("ui_up","ui_down"))
	body.walk_to(press)
	
