extends Node2D

class_name PlayerClass

signal player_death(save)

const CONSUM_BUTTON_INDEX = 2

@onready var body : Entity = get_parent()
#var inventoryUI : Control
#var skillcallUI : LineEdit
var calling_hability : bool = false
var consum_button : bool

func _ready() -> void:
	body.deathCharacter.connect(PlayerClass.respawnOnPlayerDeath)

@warning_ignore("unused_parameter")
func _process(delta):
	GameConfig.Debug_View._player_position(get_parent().position.x,get_parent().position.y)
	if Input.is_action_just_pressed("Interact") and not body.calling_skill:
		body.interact()
	elif Input.is_action_just_pressed("Place") and not body.calling_skill:
		body.placeBlock()
	elif Input.is_action_just_pressed("OpenInterface") and not body.calling_skill:
		pass
	elif Input.is_action_just_pressed("CallSkill"):
		GameConfig.call_skill(body)
	elif Input.is_action_just_pressed("OpenInventory") and not body.calling_skill:
		GameConfig.call_inventory(body)
	elif Input.is_action_just_pressed("Statistics") and not body.calling_skill:
		GameConfig.call_statistics(body)
	elif Input.is_action_just_pressed("Debbug") and not body.calling_skill:
		GameConfig.call_debbug()

@warning_ignore("unused_parameter")
func _physics_process(delta):
	#Analisar como tornar o movimento mais fluido
	if not body.calling_skill:
		var press = Vector2(Input.get_axis("move_left","move_right"),Input.get_axis("move_up","move_down"))
		body.walk_to(press)

func _input(event: InputEvent) -> void:
	if (not body.calling_skill) and (not GameConfig.on_interface_interaction):
		if event is InputEventMouseButton:
			if not event.pressed:
				#Talvez diferenciar Action com o botão direito do Esquerdo
				if consum_button :
					body.try_use_item()
				else:
					body.makeMoviment(Movimentos.MOVIMENTS.ACTION)
			else:
				consum_button = event.button_index == CONSUM_BUTTON_INDEX
				body.set_onself(body.position.distance_to(get_global_mouse_position()) < 8)
		elif event is InputEventKey:
			if event.is_action_released("move_down"):# and Input.is_action_just_released("move_down"):
				body.makeMoviment(Movimentos.MOVIMENTS.BEHIND)
				#GameConfig.Debug_View._player_position(get_parent().position.x,get_parent().position.y)
			if event.is_action_released("move_up"):# and Input.is_action_just_released("move_up"):
				body.makeMoviment(Movimentos.MOVIMENTS.FRONT)
				#GameConfig.Debug_View._player_position(get_parent().position.x,get_parent().position.y)
			if event.is_action_released("move_right"):# and Input.is_action_just_released("move_right"):
				body.makeMoviment(Movimentos.MOVIMENTS.RIGHT)
				#GameConfig.Debug_View._player_position(get_parent().position.x,get_parent().position.y)
			if event.is_action_released("move_left"):# and Input.is_action_just_released("move_left"):
				body.makeMoviment(Movimentos.MOVIMENTS.LEFT)
				#GameConfig.Debug_View._player_position(get_parent().position.x,get_parent().position.y)
			if event.is_action_released("Jump"):# and Input.is_action_just_released("Jump"):
				body.jump()
			if event.is_action_released("Squat"):# and Input.is_action_just_released("Squat"):
				body.squat()
		else:
			pass


static func respawnOnPlayerDeath():
	WorldTileMap.spawn_on_map(PlayerClass.create_player(GameConfig.Interface_Inventory,GameConfig.Interface_SkillCall,{}),0,0)

@warning_ignore("unused_parameter")
static func create_player(II = null,SCI = null,save : Dictionary = {}):
	var player = Entity.create_entity(Entities.HUMAN,true)
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
