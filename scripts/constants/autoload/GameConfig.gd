extends Node

class_name Game



const PATH_ATRIBUTE_CLASS = "res://scripts/classes/Atributos.gd"
const PATH_STATUS_CLASS = "res://scripts/classes/Status.gd"
const PATH_TERRAIN_GENERATE_CLASS = "res://scripts/classes/TerrainGenerate.gd"

const MAP_WIDTH = 256
const MAP_HEIGTH = 256

const GROUP_ENTITY_PLAYER = "player"
const GROUP_ENTITY_NPC = "npc"
const GROUP_SPAWNER = "spawner"

var WorldEntitys
var Interface_Inventory
var Interface_SkillCall
