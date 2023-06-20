extends Control

func _on_tgm_button_pressed():
	GameplayManager.ddcc_invincible = !GameplayManager.ddcc_invincible
	print("DEBUG // toggle invincible == %s" % GameplayManager.ddcc_invincible)
