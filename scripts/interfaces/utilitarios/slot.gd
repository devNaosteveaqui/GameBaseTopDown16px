extends TextureRect

@export var selectedShadow : ColorRect
@export var onHoveShadow : ColorRect
@export var item : TextureRect

func showItem(item_info):
	item.texture = item_info.texture
