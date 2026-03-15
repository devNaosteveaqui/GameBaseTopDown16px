class_name HealthBarComponent extends BaseComponents

func update_lifebar():
	entity.lifebar.size.x = 20.0*(StatusInterface.get_life_state(entity.status.general_status))
