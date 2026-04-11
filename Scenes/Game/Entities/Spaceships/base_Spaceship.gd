extends KinematicBody2D
class_name Spaceship

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

export (Team) var team = Team.PLAYER

var SPEED = 100
export var turn_speed := 3.0
export var avoidance_strength := 2.5

var dodge_direction := 0  # -1 = left, 0 = none, 1 = right
var dodge_timer := 0.0
var dodge_duration := 1  # How long to commit to a dodge direction
