extends StaticBody2D

@onready var anim = $AnimatedSprite2D
var arrow_projectile = preload("res://Scenes/Projectile/Arrow.tscn")
var enemy_array = []



var enemy
var red = true
var tower_t = "Arrow3"
var dmg_type



var is_build_u = false


var b_location = Vector2()


func _ready():
	
		
		anim.play("idle") # play animation for tower
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
			#fire()
			anim.play("attack")
			shoot()
		

	else:
		enemy = null
		anim.play("idle") #start idle animation
		
		
	# Kill upgrade ring if not in upgrade mode
	if has_node("Final") and TowerData.upgrade_mode == false:
		kill()
		
		
	
#damage the enemy whenever the Tower is off cooldown for its attack
# creates projectile
func shoot():	

	$FireArrow.play()
	
	var arrow_projectile_inst = arrow_projectile.instantiate()
	arrow_projectile_inst.b_location = b_location
	arrow_projectile_inst.enemy = enemy
	arrow_projectile_inst.tower_t = tower_t
	get_parent().add_child(arrow_projectile_inst)
	
	red = false
	await(get_tree().create_timer(TowerData.tower_data[tower_t]["rof"]).timeout)
	red = true
		

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
		$AnimatedSprite2D.flip_h = true
			
	else:
		$AnimatedSprite2D.flip_h = false
			

#detects if enemy has entered range and adds it to enemy list
func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	

#detects if enemy has left range and removes it from enemy list
func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	

#use button to add upgrade_ring to the tower and connect its buttons
func _on_button_pressed():
	
		# sends the current tower type's upgrade cost to the upgrade label
		LevelData.upgrade_cost = TowerData.tower_data[tower_t]["up_cost"]
		LevelData.sell_cost = TowerData.tower_data[tower_t]["sell"]
		
		LevelData.summoning = false #code to stop the summoing animation
		TowerData.upgrade_mode = false #updates if the Upgrade ring is current created
		
		await get_tree().create_timer(.05).timeout # timer to give UI reactivity
		
		#creates the Upgrade_ring
		var instance1 = load("res://Scenes/Core/Final.tscn").instantiate()
		add_child(instance1)
		#$Final.connect("upgrade", upgrade)
		#$Final.connect("upgrade_2", upgrade)
		#$Final.connect("upgrade_3", upgrade)
		#$Final.connect("sell", sell)
		
		#save Tower and Tier Information in global so we know what towers upgrade into
		
		#Set upgrade mode to true so we know that a upgrade ring is active somewhere
		TowerData.upgrade_mode = true
		

#func to kill the upgrade ring
func kill():
	if has_node("Final"):
		get_node("Final").free()
		print("kill up")
		pass

#upgrade the Tower based on what Tier was last selected
func upgrade():

	#subtract cost of turret from player's money
	LevelData.money = LevelData.money - TowerData.tower_data[TowerData.tower_type]["up_cost"]
	
	
	if LevelData.money > 0:
		var instance2 = load("res://Scenes/Towers/" + tower_t + "4" + ".tscn").instantiate()
		instance2.set_position(b_location)
		get_parent().add_child(instance2)
		self.queue_free()
	else:
		LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["up_cost"]
		print("not enough money")
		pass
	
func upgrade_2():
	
	LevelData.money = LevelData.money - TowerData.tower_data[TowerData.tower_type]["up_cost"]
	
	
	if LevelData.money > 0:
		var instance2 = load("res://Scenes/Towers/" + tower_t + "4" + ".tscn").instantiate()
		instance2.set_position(b_location)
		get_parent().add_child(instance2)
		self.queue_free()
	else:
		LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["up_cost"]
		print("not enough money")
		pass
	pass

func upgrade_3():
	
	LevelData.money = LevelData.money - TowerData.tower_data[TowerData.tower_type]["up_cost"]
	
	
	if LevelData.money > 0:
		var instance2 = load("res://Scenes/Towers/" + tower_t + "4" + ".tscn").instantiate()
		instance2.set_position(b_location)
		get_parent().add_child(instance2)
		self.queue_free()
	else:
		LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["up_cost"]
		print("not enough money")

	
#Add money to player for selling a tower
#delete tower after selling
func sell():
	LevelData.money = LevelData.money + TowerData.tower_data[tower_t]["sell"]
	self.queue_free()
	
#func to delete the upgrade_ring if randomly clicking on the map
func _unhandled_input(event):

	if event.is_action_released("left_click") and has_node("Final"):
		get_node("Final").free()
		TowerData.upgrade_mode = false
		LevelData.summoning = false #code to stop summoing animation
		print("unhandled kill")
		
