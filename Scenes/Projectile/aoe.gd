extends Node2D

var enemy
var tower_t
var enemy_pos = Vector2.ZERO
var fire = true

var max_speed = 600

var enemies_in_range = []

func _ready():
	#set_as_top_level(true)
	$Fire.play()
	pass

func _physics_process(delta):
	

	if enemy != null:
		
		look_at(enemy.global_position) # turns sprite to face towards enemy
		enemy_pos = enemy.global_position # save enemy position
		position = position.move_toward(enemy.global_position, max_speed * delta)# move projectile to enemy
		
		#if projectile reaches enemy deal damage to enemy and delete self
		if position == enemy.global_position:
			
			#loop throu all enemies in range and deal damage to them
			if fire:
				var loop = 0
				for i in enemies_in_range:
					enemies_in_range[loop].on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
					loop += 1
				$Fire.stop()
				$explode.play()
				print("test")
				$sprite.visible = false
				fire = false
				
				await(get_tree().create_timer(2).timeout)
				self.queue_free()
				

			
	#if enemy is dead move left over projectiles to its last spot and delete the projectile
	if enemy == null:
				position = position.move_toward(enemy_pos, max_speed * delta)# move projectile to the last spot the enemy was even after it dies
				if position == enemy_pos:
					
					#loop throu all enemies in range and deal damage to them
					if fire:
						var loop = 0
						for i in enemies_in_range:
							enemies_in_range[loop].on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
							loop += 1
						$Fire.stop()
						$sprite.visible = false
						$explode.play()
						fire = false
						
						await(get_tree().create_timer(2).timeout)
						self.queue_free()	


				if enemy == null and enemy_pos == Vector2.ZERO:
					self.queue_free()	

#add enemies to units in AOE range
func _on_impact_body_entered(body):
	enemies_in_range.append(body.get_parent())
	pass # Replace with function body.

#remove units from AOE range
func _on_impact_body_exited(body):
	enemies_in_range.erase(body.get_parent())
	pass # Replace with function body.
