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
var word = ['asteriod', 'space', 'minerals', 'spaceship', 'galaxie', 'mine', 'rock', 'fuel'].pick_random()

var current_letter_index = 0

func check_input(char):
	if is_word_complete():
		return
		
	if char == word[current_letter_index]:
		current_letter_index += 1
		return true
	else:
		return false
		
func is_word_complete():
	return current_letter_index >= word.length()
	
func on_word_completed():
	die()

func die():
	push_warning("Method not implemented, -", self.name)

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
	

	
