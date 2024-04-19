extends Node2D

var enemy
var tower_t = "cloud"
var enemy_pos = Vector2.ZERO
var enemy_array = []
var red = true

@onready var anim = $AnimatedSprite2D

func _ready():
	position = enemy
	$range/CollisionShape2D
	await(get_tree().create_timer(.2).timeout) 
	anim.play("default")
	await(get_tree().create_timer(1.4).timeout) 
	$Sprite2D.visible = true
	$range/CollisionShape2D.disabled = false
	await(get_tree().create_timer(5).timeout) 
	self.queue_free()
	
func _physics_process(delta):
	
	
	#if enemy is dead move left over projectiles to its last spot and delete the projectile
	if enemy == null:
		pass


	if enemy != null:
		if red:
			red = false
				
			#$Fire.play()
			#attack speed is limited by animation speed
			await(get_tree().create_timer(TowerData.tower_data[tower_t]["rod"]).timeout) 
			shoot()
			red = true
				
		
		
		

			
	if enemy == null and enemy_pos == Vector2.ZERO:
		self.queue_free()	


func shoot():	
	
	var loop = 0
	for i in enemy_array:
		enemy_array[loop].on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
		enemy_array[loop].speed_mod(3,.5)
		loop += 1

func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	
#detects if enemy has left range and removes it from enemy list
func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
