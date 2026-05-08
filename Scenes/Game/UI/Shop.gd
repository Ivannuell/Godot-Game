extends CanvasLayer

#@onready var player_base = $"../../Entities/Allies/Base"
@onready var miner_price = $Panel2/VBoxContainer/GridContainer/ItemSlot/Panel/Container/Price
@onready var attack_price = $Panel2/VBoxContainer/GridContainer/ItemSlot2/Panel/Container/Price


signal manufacture_requested(type)

func _ready():
	miner_price.text = str(SpaceshipFactory.Spaceships['MINER'])
	attack_price.text = str(SpaceshipFactory.Spaceships['ATTACK'])

func _on_Manufacture_pressed(type):
	emit_signal("manufacture_requested", type)
