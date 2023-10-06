extends DroneState

## Pending Retrieval State; Waiting for collection by [DDCC]

func process(_delta: float) -> STATE:
	drone.rotate(0.2)
	return STATE.NULL
