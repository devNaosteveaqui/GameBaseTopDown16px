class_name AnimationComponent extends BaseComponents

func update_animation():
	if entity.hitting:
		entity.sprite.play("hitting")
	elif entity.hitted:
		entity.sprite.play("hitted")
	elif entity.is_in_jump:
		pass
	elif entity.inMoviment == 1:
		entity.sprite.play("walk")
	else:
		entity.sprite.play("default")
func update_animation_particle():
	if entity.is_particling:
		if not entity.particles.is_visible_in_tree():
			entity.particles.show()
		entity.particles.play("relation_up")
	else:
		entity.particles.stop()
		entity.particles.play("default")
		entity.particles.hide()

func _on_animation_looped():
	if entity.sprite.animation == "hitted":
		entity.hitted = false
	if entity.sprite.animation == "hitting":
		entity.hitting = false
func _on_particle_animation_looped() -> void:
	if entity.particles.animation == "relation_up":
		entity.is_particling = false
