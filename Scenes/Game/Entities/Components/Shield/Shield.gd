extends Area2D


var active = true
var ent_count = 0

func _ready():
	pass


func _process(delta):
	$Sprite2D.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)

func _physics_process(delta: float) -> void:
	if active:
		visible = true
	else:
		visible = false


#FIXME: Bullets can also trigger the cooldown reset of the shield
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is Spaceship:
		if GameData.get_opposite_team(area.team) != get_parent().team:
			return
		else:
			add_shield_count()

	if ent_count >= 1:
		active = false
	else:
		$Timer.start()
	
	if not active:
		return
		
	
	if area is Projectile:
		if area.team == get_parent().team:
			return
			
		area.on_hit(self)


func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() is Spaceship and GameData.get_opposite_team(area.team) == get_parent().team:
		ent_count -= 1
		
func add_shield_count():
	$Timer.stop()
	self.ent_count += 1


func _on_timer_timeout() -> void:
	active = true
