extends Node

class_name CargoComponent

var capacity := 2000
var current := 0

func has_cargo() -> bool:
	return current > 0

func deposit_all() -> int:
	var amount = current
	current = 0
	return amount
	
func is_full():
	return current >= capacity
