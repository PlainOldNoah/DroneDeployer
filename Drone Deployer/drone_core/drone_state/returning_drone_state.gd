extends MovingDroneState


func enter() -> void:
	drone.facing = (drone.data.home_pos - drone.get_global_position())
#	drone.set_velocity_from_vector(drone.data.home_pos - drone.get_global_position()) # go home
