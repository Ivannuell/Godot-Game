extends Node2D

var can_launch = true
var aim_active = false
@export var missile: PackedScene = preload("res://Scenes/Game/Entities/Projectiles/missile/Missile.tscn")
@onready var team = get_parent().team

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("missile") and can_launch:
		SignalBus.emit_signal('missile_aim', self)
		aim_active = true
	
	if can_launch and aim_active:
		if Input.is_action_just_released('missile'):
			remove_aim_indicator()
			SignalBus.emit_signal("missile_launch", self)
			can_launch = false
			$Cooldown.start()
	
	#get_parent().apply_aiming_rotation(aim_active)

func _on_Timer_timeout():
	can_launch = true
	
	
func remove_aim_indicator():
	aim_active = false
	var aim = get_node_or_null('AimIndicator')
	
	if aim:
		remove_child(aim)
