extends Node2D

var enemy
var tower_t

var red = true
var time_zapped = 0.0
var damage
var tweet = false


func _ready():
	$laser.play()
	# set damage for the Tower
	damage = TowerData.tower_data[tower_t]["damage"]
	
	#create animation to fire laser at enemy
	var tween = create_tween()
	tween.tween_method(create_beam, to_global(Vector2.ZERO), enemy.position, .1)
	await(get_tree().create_timer(.1).timeout) 
	tweet = true

func _physics_process(delta):

	
	if tweet:
		
		if enemy != null:

			#animates the endpoint of the line to where the enemy is
			$Line2D.set_point_position(1,to_local(enemy.position))
			$EndParticles2D2.position = to_local(enemy.position)
			if red:
		
				red = false
				
				#attack speed for tower
				await(get_tree().create_timer(TowerData.tower_data[tower_t]["rof"]).timeout) 
				#damage and damage escalation
				damage = damage * 2
				enemy.on_hit(damage,TowerData.tower_data[tower_t]["damage_type"])
				red = true

		#reset tower damage to starting amount and delete beam if enemy dies
		if get_parent().enemy_array.has(enemy) == false or enemy == null:
			damage = TowerData.tower_data[tower_t]["damage"]
			self.queue_free()
			pass
		

#sets the end point of the line
func create_beam(vec):
	$Line2D.set_point_position(1,to_local(vec))
	pass
