extends Node

class_name Game

enum OBJECT_TYPE {ENTITY,ITEM,SPAWN_AREA,HABILITY,PLACEABLE}

const PATH_ATRIBUTE_CLASS = "res://scripts/classes/Atributos.gd"
const PATH_STATUS_CLASS = "res://scripts/classes/Status.gd"
const PATH_TERRAIN_GENERATE_CLASS = "res://scripts/classes/TerrainGenerate.gd"

# Tamanho do mapa em Tiles
const MAP_WIDTH = 256
const MAP_HEIGTH = 256

# Todos em quantidades de Chunks
const CHUNKS_IN_NOTIFIER = 4
const NOTIFIER_DIMENSION = Vector2i(2,2)
const CHUNKS_IN_ENABLE = 16
const ENABLE_DIMENSION = Vector2i(4,4)

const GROUP_ENTITY_PLAYER = "player"
const GROUP_ENTITY_NPC = "npc"
const GROUP_ENTITY_TO_UPDATE = "entity_to_update"
const GROUP_SPAWNER = "spawner"
const GROUP_RAYCAST = "raycast"
const GROUP_INTERACTABLE = "interactable"
const GROUP_STATEMACHINE = "state_machine"


var WorldEntitys
var Interface_Inventory
var Interface_SkillCall
var Game_Notification
var Debug_View
var Interface_Statistics

var on_interface_interaction : bool = false

func _physics_process(delta: float) -> void:
	SMScript.sort_execute_states_machine()
	#Debug_View._analytics_info()

func place_on_world(obj):
	WorldEntitys.placeOnWorld(obj)

func change_obj_chunk(obj):
	WorldEntitys.steped_on_new_chunk(obj)

func get_objects_on_world_list():
	return WorldEntitys.get_children()

func has_this_object_on_world(obj_name):
	return WorldEntitys.get_node_or_null(obj_name)

func call_inventory(entity):
	if GameConfig.Interface_Inventory.is_visible_in_tree():
		GameConfig.Interface_Inventory.hide()
		GameConfig.on_interface_interaction = false
	else:
		GameConfig.Interface_Inventory.show()
		GameConfig.Interface_Inventory.showInventory(entity.inventory)
		GameConfig.on_interface_interaction = true

func call_skill(entity):
	if GameConfig.Interface_SkillCall.is_visible_in_tree():
		GameConfig.Interface_SkillCall.hide()
		entity.call_magic(GameConfig.Interface_SkillCall.text)
		entity.calling_skill = false
	else:
		GameConfig.Interface_SkillCall.show()
		GameConfig.Interface_SkillCall.clear()
		GameConfig.Interface_SkillCall.grab_focus()
		entity.calling_skill = true

func call_statistics(entity):
	if GameConfig.Interface_Statistics.is_visible_in_tree():
		GameConfig.Interface_Statistics.hide()
	else:
		GameConfig.Interface_Statistics.show()
		GameConfig.Interface_Statistics.grab_focus()
		GameConfig.Interface_Statistics.showEstatisticas(entity)

func call_debbug():
	if GameConfig.Debug_View.is_visible_in_tree():
		GameConfig.Debug_View.hide()
	else:
		GameConfig.Debug_View.show()

func create_object(obj):
	#Classes : Entity, Placeable, Habilidade, Spawner
	#chamar essa função no create de cada objeto para adicionar ele ao ciclo de reciclagem
	pass
