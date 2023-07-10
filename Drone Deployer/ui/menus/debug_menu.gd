extends Control

func _on_tgm_button_pressed():
	GameplayManager.ddcc_invincible = !GameplayManager.ddcc_invincible
	print("DEBUG // toggle invincible == %s" % GameplayManager.ddcc_invincible)


func _on_create_rand_augment_pressed():
	AugmentFactory.create_rand_augment()
	print("DEBUG // created random augment")
#	print(augment.get_modulate(), ", ", augment.value)


func _on_add_scrap_pressed():
	if sign(%ScrapAmount.get_value()) == 1:
		GameplayManager.add_scrap(%ScrapAmount.get_value())
	else:
		GameplayManager.remove_scrap(absi(%ScrapAmount.get_value()))
	print("DEBUG // added scrap")


func _on_add_health_pressed():
	GameplayManager.ddcc_health += %HealthAmount.get_value()
	print("DEBUG // added health")
