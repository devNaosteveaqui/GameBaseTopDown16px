extends AnimatedSprite2D

class_name ResourceMap

@export var sprite : AnimatedSprite2D
@export var shape : CollisionShape2D

static func createResource(resourceType):
	var resource = load("res://REMAKE/scenes/worldmap/Resource.tscn").instantiate()
	resource.setResourceAniamtion(resourceType.animation)
	resource.setShape(resourceType.shape)
	return resource

func setResourceAniamtion(spriteItem):
	sprite.sprite_frames = load("res://REMAKE/resources/resource/animation/" + spriteItem)

func setShape(shapeItem):
	shape.shape=load("res://REMAKE/resources/resource/shape/" + shapeItem)
