class_name DetectionComponent extends BaseComponents

func add_body_detected(body):
	entity.bodys_on_detect.append(body)

func add_body_on_range(body):
	entity.bodys_on_range_attack.append(body)

func remove_body_detected(body):
	entity.bodys_on_detect.erase(body)

func remove_body_on_range(body):
	entity.bodys_on_range_attack.erase(body)

func get_targets_nearby(): #maybe del
	return entity.bodys_on_detect
	#return area_detect.get_overlapping_bodies()
