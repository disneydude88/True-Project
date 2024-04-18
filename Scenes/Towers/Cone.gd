extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var anim2 = $North/CollisionPolygon2D/AnimatedSprite2D2
#@onready var anim2 = $North/AnimatedSprite2D2
var projectile = preload("res://Scenes/Projectile/Snowball.tscn")
var aoe_projectile = preload("res://Scenes/Projectile/aoe.tscn")
var enemy_array = []



var enemy
var red = true
var tower_t
var fire = false
var attack = true

var rotate_cone = false


var Tier = 1


var is_build_u = false


var b_location = Vector2()

var tower_location
var target_location

func _ready():
	
		
		anim.play("idle") # play animation for tower
		tower_t = TowerData.tower_type # get the last type of tower that has been built. This is type that this turret is.
		
		#set range for turret from TowerData
		b_location = self.global_position
		tower_location =  self.global_position.x
	
func _physics_process(delta):
	
	#find target location
	target_location = $North/CollisionPolygon2D/CollisionShape2D/CollisionShape2D.global_position.x
	
	#flip turret in the direction of the target cone
	flip_turret()
	
	#checks if tower has detected any enemies.  Selects enemy and makes tower face towards enemy
	if enemy_array.size() !=0:

		if attack:
			anim.play("attack")
			anim2.play("attack")
			$attack.play()
			attack = false
		if $North/CollisionPolygon2D/AnimatedSprite2D2.animation == "attack":
			fire = true
		if $North/CollisionPolygon2D/AnimatedSprite2D2.animation == "idle":
			fire = false
		if red and fire:
			
			# damage all enemies whenever the Tower is off cooldown for its attack
			red = false
			await(get_tree().create_timer(TowerData.tower_data[tower_t]["rod"]).timeout) #rate of damage while in flamethrower
			shoot()
			red = true
			
			#anim.speed_scale
			 #play attack animation when firing
	#else:
		#enemy = null
		#await(get_tree().create_timer(.5))
		#anim.play("idle") #start idle animation
		#anim2.play("idle")
		
	# Kill upgrade ring if not in upgrade mode
	if has_node("upgrade_ring") and TowerData.upgrade_mode == false:
		kill()
		
		#rotates player UI for tower targeting
	if rotate_cone:
		
		$TargetingCone.look_at(get_global_mouse_position()) #moves the Player ui for targeing
		$TargetingCone.visible = true # set the PLayer ui as visable to player
		$TargetingCone2.look_at(get_global_mouse_position()) #moves the Player ui for targeing
		if Input.is_action_pressed("left_click"):
			
			$North/CollisionPolygon2D.look_at(get_global_mouse_position()) # sets targeting for towerc
			rotate_cone = false
			$TargetingCone.visible = false
			$TargetingCone2.visible = false
		
	else:
		if Input.is_action_pressed("left_click"):
			$TargetingCone.visible = false
			$TargetingCone2.visible = false
		
# damage all enemies in cone
func shoot():	
	
	var loop = 0
	for i in enemy_array:
		enemy_array[loop].on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
		loop += 1
		
func _on_animated_sprite_2d_2_animation_finished():
	anim.play("idle") #start idle animation
	anim2.play("idle")
	await(get_tree().create_timer(TowerData.tower_data[tower_t]["rof"]).timeout) # controls how often the flame is up
	attack = true
	pass # Replace with function body.

	
# detects if enemy is left or right of the tower and flips tower accordingly
func flip_turret():

	if target_location < tower_location:
		$AnimatedSprite2D.flip_h = false
	
	else:
		$AnimatedSprite2D.flip_h = true

#use button to add upgrade_ring to the tower and connect its buttons
func _on_button_pressed():
	
		#reveal initial targeting cone
		$TargetingCone2.visible = true
		
		
		# sends the current tower type's upgrade cost to the upgrade label
		LevelData.upgrade_cost = TowerData.tower_data[TowerData.tower_type]["up_cost"]
		LevelData.sell_cost = TowerData.tower_data[TowerData.tower_type]["sell"]
		
		LevelData.summoning = false #code to stop the summoing animation
		TowerData.upgrade_mode = false #updates if the Upgrade ring is current created
		
		await get_tree().create_timer(.05).timeout # timer to give UI reactivity
		
		#creates the Upgrade_ring
		var instance1 = load("res://Scenes/Core/upgrade_ring.tscn").instantiate()
		instance1.cone = true
		add_child(instance1)
		$upgrade_ring.connect("upgrade", upgrade)
		$upgrade_ring.connect("sell", sell)
		$upgrade_ring.connect("select_cone", select_cone)
		
		#save Tower and Tier Information in global so we know what towers upgrade into
		TowerData.last_selected = tower_t
		TowerData.last_selected_tier = Tier
		
		#Set upgrade mode to true so we know that a upgrade ring is active somewhere
		TowerData.upgrade_mode = true

#turn on targeting
func select_cone():
	rotate_cone = true
	

#func to kill the upgrade ring
func kill():
	if has_node("upgrade_ring"):
		get_node("upgrade_ring").free()
		print("kill up")
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
	

func _unhandled_input(event):
		
	#delete the upgrade_ring if randomly clicking on the map
	if event.is_action_released("left_click") and has_node("upgrade_ring"):
		get_node("upgrade_ring").free()
		TowerData.upgrade_mode = false
		LevelData.summoning = false #code to stop summoing animation
		print("unhandled kill")
		

func _on_north_body_entered(body):
	enemy_array.append(body.get_parent())
	pass # Replace with function body.

func _on_north_body_exited(body):
	enemy_array.erase(body.get_parent())
	pass # Replace with function body.
	
