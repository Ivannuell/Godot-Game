extends Node

signal game_over(base)


signal gun_shoot(gun)
signal missile_launch(launcher)
signal missile_aim(launcher)

signal explosion(pos, radius, damage_data)
signal hit(source)

signal entity_damaged(hurtbox, damage_data)
signal entity_hit()
signal entity_died(entity)

signal cargo_spawned(cargo)
signal cargo_collected(cargo, target)

signal start_mining(mining_tool)

signal minerals_changed(team, value)

#--- Typing attack Signals ---------
signal activate_enemy(enemy)
signal deactivate_enemy(enemy)

signal enter_enemy(enemy)
signal exit_enemy(enemy)
signal no_enemy()
#---
