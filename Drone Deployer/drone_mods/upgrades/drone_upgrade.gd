class_name DroneUpgrade
extends Node2D

## The Behavior for drone upgrades, attaches to drones

var drone:Drone

## Initializes the upgrade, called on adding to drone
func init(linked_drone:Drone):
	drone = linked_drone

## Different upgrade activations/uses
## On collision with [Drone, DDCC, enemy, world, etc.]
## On state change
## Timer timeout
## Constantly during process
## At startup
## User input?
