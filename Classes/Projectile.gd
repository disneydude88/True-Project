class_name Projectile
extends Node2D

var enemy
var tower_t
var enemy_pos = Vector2.ZERO

var max_speed = 600

func _ready():
	#set_as_top_level(true)
	pass

func _physics_process(delta):
	

	#check if enemy exists and move projectile to it
	if enemy != null:
		look_at(enemy.global_position) # turns sprite to face towards enemy
	
	if enemy != null:
		
		
		position = position.move_toward(enemy.global_position, max_speed * delta) #moves the projectile towards enemy
		enemy_pos = enemy.global_position #Saves the last spot the enemy was at
	else:
		position = position.move_toward(enemy_pos, max_speed * delta)# move projectile to the last spot the enemy was even after it dies
	
	if enemy != null:
		
		#Once the projectile reaches the enemy deal damage and delete projectile
		if position == enemy.global_position:
			enemy.on_hit(TowerData.tower_data[tower_t]["damage"])
			self.queue_free()
	else:
		#if enemy is already dead continue to move projectile to where the enemy dies then delete self
		if position == enemy_pos:
			self.queue_free()	
