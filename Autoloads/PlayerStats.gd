extends Node

signal booster_fuel_changed(value)

var booster_fuel := 10.0 setget set_booster_fuel, get_booster_fuel
var max_boost_fuel = 10.0

var boost_fuel_persec = 2
var boost_speed_multi = 3
var boost_fuel_regen = 1

func get_booster_fuel():
	return booster_fuel

func set_booster_fuel(value):
	booster_fuel = value
	emit_signal("booster_fuel_changed", value)
