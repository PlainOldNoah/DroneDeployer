extends Control

func _on_tgm_button_pressed():
	GameplayManager.ddcc_invincible = !GameplayManager.ddcc_invincible
	print("DEBUG // toggle invincible == %s" % GameplayManager.ddcc_invincible)


func _on_create_rand_augment_pressed():
	AugmentFactory.create_rand_augment()
#	print(augment.get_modulate(), ", ", augment.value)
