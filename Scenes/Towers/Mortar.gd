extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var anim2 = $North/CollisionPolygon2D/AnimatedSprite2D2

var projectile = preload("res://Scenes/Projectile/MortarAmmo.tscn")

var enemy_array = []

var enemy
var red = true
var tower_t

var select_zone = false

var Tier = 1

var is_build_u = false

var b_location = Vector2()

var tower_location

var launch =  false
var reset = false

func _ready():
	
		
		#anim.play("idle") # play animation for tower
		tower_t = "Mortar" # get the last type of tower that has been built. This is type that this turret is.
		
		#Tower location
		b_location = self.global_position
		tower_location =  self.global_position.x
	
func _physics_process(delta):
	
	
	#checks if tower has detected any enemies.  Selects enemy and makes tower face towards enemy
	if enemy_array.size() !=0:
		
		
		if red:

			# damage all enemies whenever the Tower is off cooldown for its attack
			red = false
			launch = true
			
			# damage completes after the animation for the projectile finishes
			anim.play("attack")
			$Fire.play()
			await(get_tree().create_timer(TowerData.tower_data[tower_t]["rof"]).timeout) 
			red = true
			
	
	else:
		enemy = null
		await(get_tree().create_timer(.5))
		
	# Kill upgrade ring if not in upgrade mode
	if has_node("upgrade_ring") and TowerData.upgrade_mode == false:
		kill()
		
		#If targeting button is pressed enter target mode
	if select_zone:
		
	
		#move around target area. Show current target and potential target zones
		$targeting.position = to_local(get_global_mouse_position())
		$targeting.visible = true # set the PLayer ui as visable to player
		$range/Ellipse.visible = true
		
		# if you left click while in target mode finish targeting
		if Input.is_action_pressed("left_click"):
			
			$range.position = to_local(get_global_mouse_position()) # sets targeting for towerc
			$targeting.visible = false
			$range/Ellipse.visible = false
			select_zone = false
	else:
		if Input.is_action_pressed("left_click"):
			$targeting.visible = false
			$range/Ellipse.visible = false
	
		#if player selects a build spot while selecting a cone target the targeting will cancel
		
func _on_animated_sprite_2d_animation_finished():
	
	
	if launch == true:
		
		#add instance of projectile and send target position to projectile
		var projectile_inst = projectile.instantiate()
		projectile_inst.launch = true
		projectile_inst.target_position = to_global($range.position)
		add_child(projectile_inst)
		
		anim.play("reset")
		launch = false	
		
# damage all enemies in target zone
func shoot():	
	
	var loop = 0
	for i in enemy_array:
		enemy_array[loop].on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
		loop += 1
		
	
#Add and remove enemies that enter and exit detection range
func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())

func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	
	
#func _on_button_button_down():
	##$range/Ellipse.visible = false
	#pass
#func _on_button_button_up():
	#
		#
		#LevelData.target_mode = true
		#$range/Ellipse.visible = true
		#
		## sends the current tower type's upgrade cost to the upgrade label
		#LevelData.upgrade_cost = TowerData.tower_data[TowerData.tower_type]["up_cost"]
		#LevelData.sell_cost = TowerData.tower_data[TowerData.tower_type]["sell"]
		#
		#LevelData.summoning = false #code to stop the summoing animation
		#TowerData.upgrade_mode = false #updates if the Upgrade ring is current created
		#
		#await get_tree().create_timer(.05).timeout # timer to give UI reactivity
		#
		##creates the Upgrade_ring
		#var instance1 = load("res://Scenes/Core/upgrade_ring.tscn").instantiate()
		#instance1.cone = true
		#add_child(instance1)
		#$upgrade_ring.connect("upgrade", upgrade)
		#$upgrade_ring.connect("sell", sell)
		#$upgrade_ring.connect("select_cone", select_target)
		#
		##save Tower and Tier Information in global so we know what towers upgrade into
		#TowerData.last_selected = tower_t
		#TowerData.last_selected_tier = Tier
		#
		##Set upgrade mode to true so we know that a upgrade ring is active somewhere
		#TowerData.upgrade_mode = true
	#
	
#use button to add upgrade_ring to the tower and connect its buttons
func _on_button_pressed():

		$range/Ellipse.visible = true
		
		# sends the current tower type's upgrade cost to the upgrade label
		LevelData.upgrade_cost = TowerData.tower_data[TowerData.tower_type]["up_cost"]
		LevelData.sell_cost = TowerData.tower_data[TowerData.tower_type]["sell"]
		
		LevelData.summoning = false #code to stop the summoing animation
		TowerData.upgrade_mode = false #updates if the Upgrade ring is current created
		
		await get_tree().create_timer(.05).timeout # timer to give UI reactivity
		
		#creates the Upgrade_ring and connect buttons
		var instance1 = load("res://Scenes/Core/upgrade_ring.tscn").instantiate()
		instance1.cone = true
		add_child(instance1)
		$upgrade_ring.connect("upgrade", upgrade)
		$upgrade_ring.connect("sell", sell)
		$upgrade_ring.connect("select_cone", select_target)
		
		#save Tower and Tier Information in global so we know what towers upgrade into
		TowerData.last_selected = tower_t
		TowerData.last_selected_tier = Tier
		
		#Set upgrade mode to true so we know that a upgrade ring is active somewhere
		TowerData.upgrade_mode = true
		
#turn on targeting
func select_target():
	select_zone = true
	
#func to kill the upgrade ring
func kill():
	if has_node("upgrade_ring"):
		get_node("upgrade_ring").free()
		pass

#upgrade the Tower based on what Tier was last selected
func upgrade():

	#subtract cost of turret from player's money
	LevelData.money = LevelData.money - TowerData.tower_data[TowerData.tower_type]["up_cost"]
	
	
	if LevelData.money > 0:
		if Tier == 1:
			#load the Tower instance based on tower type and Tier
			var instance2 = load("res://Scenes/Towers/" + tower_t + "2" + ".tscn").instantiate()
			instance2.set_position(b_location) # set location for the new tower
			instance2.Tier = 2 # assign the new Tower's Tier
			get_parent().add_child(instance2) # create the Tower connected to the level
			TowerData.tower_type = tower_t + "2"
			print(TowerData.tower_type)
			self.queue_free() # delete the old tower
		if Tier == 2:
			var instance2 = load("res://Scenes/Towers/" + tower_t + "3" + ".tscn").instantiate()
			instance2.set_position(b_location)
			instance2.Tier = 3
			TowerData.tower_type = tower_t + "3"
			get_parent().add_child(instance2)
			self.queue_free()
		if Tier == 3:
			var instance2 = load("res://Scenes/Towers/" + tower_t + "4" + ".tscn").instantiate()
			instance2.set_position(b_location)
			get_parent().add_child(instance2)
			self.queue_free()
	else:
		LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["up_cost"]
		print("not enough money")
		pass
	
#Add money to player for selling a tower
#delete tower after selling
func sell():
	
	LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["sell"]
	self.queue_free()
	
#delete the upgrade_ring if randomly clicking on the map
func _unhandled_input(event):

	
	if event.is_action_released("left_click") and has_node("upgrade_ring"):
		
		get_node("upgrade_ring").free()
		TowerData.upgrade_mode = false
		LevelData.summoning = false #code to stop summoing animation
		print("unhandled kill")
		
		$targeting.visible = false
		$range/Ellipse.visible = false
		select_zone = false





