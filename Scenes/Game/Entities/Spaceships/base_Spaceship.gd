extends CharacterBody2D
class_name Spaceship

enum Team {
	PLAYER,
	ENEMY,
	NEUTRAL
}

@export var team: Team = Team.PLAYER

var SPEED = 100
@export var turn_speed := 3.0
@export var avoidance_strength := 2.5

var dodge_direction := 0  # -1 = left, 0 = none, 1 = right
var dodge_timer := 0.0
var dodge_duration := 1  # How long to commit to a dodge direction

var active = false
var index = 0
var word = ['asteriod', 'space', 'minerals'].pick_random()



func activate():
	push_warning("Method not implemented, -", self.name)
	
func deactivate():
	push_warning("Method not implemented, -", self.name)
	
func update_index(i):
	push_warning("Method not implemented, -", self.name)
	
func show_word():
	push_warning("Method not implemented, -", self.name)

func hide_word():
	push_warning("Method not implemented, -", self.name)
	
