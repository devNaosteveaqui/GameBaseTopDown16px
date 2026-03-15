class_name TargetingComponent extends BaseComponents

func has_targeted():
	var collider = entity.get_target_on_range()
	if !(collider == entity.last_interactable or collider == null or collider == self):
		if entity.last_interactable != null:
			if entity.last_interactable.has_method("targeted_effect_deactive"):
				entity.last_interactable.targeted_effect_deactive()
		#if collider.is_in_group(GameConfig.GROUP_INTERACTABLE):
		if collider.has_method("targeted_effect_active"):
			entity.last_interactable = collider
			collider.targeted_effect_active()
	elif (collider == null and entity.last_interactable != null):
		entity.last_interactable.targeted_effect_deactive()
		entity.last_interactable = null

func set_look_on_target(target):
	if not target.is_equal_approx(Vector2(0,0)):
		entity.look_to(target)
