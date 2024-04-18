extends Node2D

var enemy
var enemy2
var tower_t
var enemy_pos = Vector2.ZERO


var max_speed = 400

func _ready():
	#set_as_top_level(true)
	pass

func _physics_process(delta):
	
	
	#if enemy is dead move left over projectiles to its last spot and delete the projectile
	if enemy == null:
		position = position.move_toward(enemy_pos, max_speed * delta)# move projectile to the last spot the enemy was even after it dies
		if position == enemy_pos:
			self.queue_free()	

	if enemy != null:
		
		look_at(enemy.global_position) # turns sprite to face towards enemy
		enemy_pos = enemy.global_position # save enemy position
		position = position.move_toward(enemy.global_position, max_speed * delta)# move projectile to enemy
		
		#if projectile reaches enemy deal damage to enemy and delete self
		if position == enemy.global_position:
			enemy_pos = enemy.global_position
			enemy.on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
			self.queue_free()
			
	if enemy == null and enemy_pos == Vector2.ZERO:
		self.queue_free()	

