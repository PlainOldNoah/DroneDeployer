extends Label

var linked_drone:Drone = null


# Sets a new linked drone
func link_to_drone(drone:Drone):
	if drone != linked_drone:
		
		if linked_drone != null:
			linked_drone.disconnect("stats_updated", update_labels)
		
		linked_drone = drone
		update_labels(linked_drone)
		var _ok := linked_drone.connect("stats_updated", update_labels)


# Updates its labels to display parameter drones stats
func update_labels(drone:Drone):
	var lds:Dictionary = drone.stats
	text = "%s\nSpeed: %d\nDamage: %d\nBattery: %d" % [linked_drone.name, lds.max_speed, lds.damage, lds.max_battery]


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
