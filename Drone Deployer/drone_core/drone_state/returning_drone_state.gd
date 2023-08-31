extends MovingDroneState


func enter() -> void:
	drone.set_velocity_from_vector(drone.data.home_pos - drone.get_global_position()) # go home
