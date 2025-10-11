extends Label

@export var sprite : AnimationPlayer

func show_text_hitted():
	self.text = "Hitted"
	sprite.play("Text_Upping")

func show_text_miss():
	self.text = "Miss"
	sprite.play("Text_Upping")
