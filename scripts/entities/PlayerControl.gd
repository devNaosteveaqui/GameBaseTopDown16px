extends Node2D

class_name PlayerClass

signal player_death(save)

@onready var body : Entity = get_parent()

#var inventoryUI : Control
#var skillcallUI : LineEdit
var calling_hability : bool = false

func _ready() -> void:
	body.deathCharacter.connect(playerDeath)

func _process(delta):
	if Input.is_action_just_pressed("Interact") and not body.calling_skill:
		body.interact()
	elif Input.is_action_just_pressed("Place") and not body.calling_skill:
		body.placeBlock()
	elif Input.is_action_just_pressed("OpenInterface") and not body.calling_skill:
		pass
	elif Input.is_action_just_pressed("CallSkill"):
		if GameConfig.Interface_SkillCall.is_visible_in_tree():
			GameConfig.Interface_SkillCall.hide()
			body.call_magic(GameConfig.Interface_SkillCall.text)
			body.calling_skill = false
		else:
			GameConfig.Interface_SkillCall.show()
			GameConfig.Interface_SkillCall.clear()
			GameConfig.Interface_SkillCall.grab_focus()
			body.calling_skill = true
	elif Input.is_action_just_pressed("OpenInventory") and not body.calling_skill:
		if GameConfig.Interface_Inventory.is_visible_in_tree():
			GameConfig.Interface_Inventory.hide()
		else:
			GameConfig.Interface_Inventory.show()
			GameConfig.Interface_Inventory.showInventory(body.inventory)

func _physics_process(delta):
	#Analisar como tornar o movimento mais fluido
	if not body.calling_skill:
		var press = Vector2(Input.get_axis("move_left","move_right"),Input.get_axis("move_up","move_down"))
		body.walk_to(press)

func _input(event: InputEvent) -> void:
	print(body.calling_skill)
	if not body.calling_skill:
		if event is InputEventMouseButton:
			if not event.pressed:
				body.makeMoviment(Movimentos.MOVIMENTS.ACTION)
				print(event)
			else:
				body.set_onself(body.position.distance_to(get_global_mouse_position()) < 8)
				#if body.position.distance_to(get_global_mouse_position()) < 8:
					#body.set_onself(true)
				#else:
					#body.set_onself(false)
		elif event is InputEventKey:
			if event.is_action_released("move_down"):# and Input.is_action_just_released("move_down"):
				body.makeMoviment(Movimentos.MOVIMENTS.BEHIND)
			if event.is_action_released("move_up"):# and Input.is_action_just_released("move_up"):
				body.makeMoviment(Movimentos.MOVIMENTS.FRONT)
			if event.is_action_released("move_right"):# and Input.is_action_just_released("move_right"):
				body.makeMoviment(Movimentos.MOVIMENTS.RIGHT)
			if event.is_action_released("move_left"):# and Input.is_action_just_released("move_left"):
				body.makeMoviment(Movimentos.MOVIMENTS.LEFT)
			if event.is_action_released("Jump"):# and Input.is_action_just_released("Jump"):
				body.jump()
			if event.is_action_released("Squat"):# and Input.is_action_just_released("Squat"):
				body.squat()

func playerDeath():
	emit_signal("player_death",{})

static func create_player(II,SCI,save : Dictionary = {}):
	var player = Entity.create_entity(Entities.HUMAN)
	var playercontrol = load("res://scenes/entities/PlayerControl.tscn").instantiate()
	#playercontrol.inventoryUI = GameConfig.Interface_Inventory#II# inventoryInterface
	#playercontrol.skillcallUI = GameConfig.Interface_SkillCall#SCI#skillcallInterface
	#playercontrol.player_death.connect(spawnPlayer)
	player.add_to_group(Game.GROUP_ENTITY_PLAYER)
	player.add_child(playercontrol)
	player.add_child(Camera2D.new())
	if not save.is_empty():
		pass
	return player
	#if save.is_empty():
		#map.spawn_on_map(player,0,0)
	#else:
		#pass
