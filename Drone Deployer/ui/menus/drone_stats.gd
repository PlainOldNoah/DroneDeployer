extends Label


var linked_drone:Drone = null


func _ready():
	update_labels()


# Sets a new linked drone
func link_to_drone(drone:Drone):
	if drone != linked_drone:
		linked_drone = drone


# Updates itself to reflect the current stats
func update_labels():
	text = "Speed: %d\nDamage: %d\nBattery: %d" % [0, 1, 2]


#Speed: 10 (40)
#Damage: 4 (3)
#Battery: 0
#Battery Drain:0
#Crit Chance: 0
#Crit Bonus: 0
#Pickup Range: 0
#
#Bounces: 0
#Acceleration: 0
#
#Enemies Defeated: 0
#Scrap Delivered: 0
#Times Deployed: 0
