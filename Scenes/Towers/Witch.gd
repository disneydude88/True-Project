extends StaticBody2D

@onready var anim = $AnimatedSprite2D
var projectile = preload("res://Scenes/Projectile/Snowball.tscn")


var enemy_array = []



var enemy
var red = true
var fire = false

var tower_t
var dmg_type



var is_build_u = false


var b_location = Vector2()


func _ready():
	
		
		anim.play("idle") # play animation for tower
		tower_t = TowerData.tower_type # get the last type of tower that has been built. This is type that this turret is.
		dmg_type = TowerData.tower_data[tower_t]["damage_type"]
		
		#set range for turret from TowerData
		self.get_node("range/CollisionShape2D").get_shape().radius = 0.5 * TowerData.tower_data[tower_t]["range"]
		b_location = self.global_position
		
		
	
	
func _physics_process(delta):
	
	#checks if tower has detected any enemies. Selects enemy and makes tower face towards enemy
	if enemy_array.size() !=0:
		select_enemy()
		flip_turret()
		
		if red:
			
			red = false
			fire = true
			
			anim.play("attack")
			$Fire.play()
			#attack speed is limited by animation speed
			await(get_tree().create_timer(TowerData.tower_data[tower_t]["rof"]).timeout) 
			red = true
		

	else:
		enemy = null
		anim.play("idle") #start idle animation
		
		
	# Kill upgrade ring if not in upgrade mode
	if has_node("upgrade_ring") and TowerData.upgrade_mode == false:
		kill()
		
		
	
#damage the enemy whenever the Tower is off cooldown for its attack
# creates projectile
func shoot():	
		
		var projectile_inst = projectile.instantiate()
		projectile_inst.position =  b_location
		projectile_inst.tower_t = tower_t
		projectile_inst.enemy = enemy # set the enemy var of the proj as the current target of the tower
		get_parent().add_child(projectile_inst)
		
		
func _on_animated_sprite_2d_animation_finished():
	if fire:
		shoot()
		fire = false
	
#func to find an enemy and then pick the one furthest on the path
func select_enemy():
	var enemy_progress_array = []
	var enemy_time_array = []
	var enemy_index
	
	#checks each enemy that has been detected for how far along path they are
	for i in enemy_array:
		enemy_progress_array.append(i.progress)
		
	for i in enemy_array:
		enemy_time_array.append(i.time)
		
	# finds enemy futhest on path
	var max_progress = enemy_progress_array.max()
	var max_time = enemy_time_array.max()
	
	if max_progress == null:
		enemy_index = enemy_time_array.find(max_time)
	else:
		#print("progress")
		enemy_index = enemy_progress_array.find(max_progress)
	#returns farthest enemy
	enemy = enemy_array[enemy_index]
	
# detects if enemy is left or right of the tower and flips tower accordingly
func flip_turret():
	
	var pos_x = enemy.position.x # offset for Tower hitbox being in top left corner
	var tur_pos_x = position.x
	
	if pos_x < tur_pos_x:
		$AnimatedSprite2D.flip_h = false
		#print("left")
	else:
		$AnimatedSprite2D.flip_h = true
		#print("right")
#detects if enemy has entered range and adds it to enemy list
func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	
#detects if enemy has left range and removes it from enemy list
func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	
#use button to add upgrade_ring to the tower and connect its buttons
func _on_button_pressed():
	
		# sends the current tower type's upgrade cost to the upgrade label
		LevelData.upgrade_cost = TowerData.tower_data[TowerData.tower_type]["up_cost"]
		LevelData.sell_cost = TowerData.tower_data[TowerData.tower_type]["sell"]
		
		LevelData.summoning = false #code to stop the summoing animation
		TowerData.upgrade_mode = false #updates if the Upgrade ring is current created
		
		await get_tree().create_timer(.05).timeout # timer to give UI reactivity
		
		#creates the Upgrade_ring
		var instance1 = load("res://Scenes/Core/upgrade_ring.tscn").instantiate()
		add_child(instance1)
		$upgrade_ring.connect("upgrade", upgrade)
		$upgrade_ring.connect("sell", sell)

		
		#Set upgrade mode to true so we know that a upgrade ring is active somewhere
		TowerData.upgrade_mode = true
		
#func to kill the upgrade ring
func kill():
	if has_node("upgrade_ring"):
		get_node("upgrade_ring").free()
		print("kill up")
		pass

#upgrade the Tower
func upgrade():

	#subtract cost of turret from player's money
	LevelData.money = LevelData.money - TowerData.tower_data[TowerData.tower_type]["up_cost"]
	if LevelData.money > 0:
			#load the Tower instance 
			var instance2 = load("res://Scenes/Towers/Witch2.tscn").instantiate()
			instance2.set_position(b_location) # set location for the new tower
			get_parent().add_child(instance2) # create the Tower connected to the level
			self.queue_free() # delete the old tower
	else:
		LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["up_cost"]
		print("not enough money")
		pass
	
#Add money to player for selling a tower
#delete tower after selling
func sell():
	LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["sell"]
	self.queue_free()
	
#func to delete the upgrade_ring if randomly clicking on the map
func _unhandled_input(event):

	if event.is_action_released("left_click") and has_node("upgrade_ring"):
		get_node("upgrade_ring").free()
		TowerData.upgrade_mode = false
		LevelData.summoning = false #code to stop summoing animation
		print("unhandled kill")
		

