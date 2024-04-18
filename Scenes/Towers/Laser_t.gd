extends StaticBody2D

@onready var anim = $AnimatedSprite2D
var projectile = preload("res://Scenes/Projectile/laser.tscn")


var enemy_array = []



var enemy
var red = true

var tower_t
var dmg_type

var Tier = 1


var is_build_u = false


var b_location = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	tower_t = TowerData.tower_type # get the last type of tower that has been built. This is type that this turret is.
	dmg_type = TowerData.tower_data[tower_t]["damage_type"]
	
	#set range for turret from TowerData
	self.get_node("range/CollisionShape2D").get_shape().radius = 0.5 * TowerData.tower_data[tower_t]["range"]
	b_location = self.global_position
	
	
	
	
	anim.play("idle")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#checks if tower has detected any enemies. Selects enemy
	if enemy_array.size() != 0:
		select_enemy()
		
		#makes sure there is only one laser at a time
		if has_node("Laser"):
			pass
		else:
			shoot()

		

	else:
		enemy = null
		#nim.play("idle") #start idle animation
		
		
	# Kill upgrade ring if not in upgrade mode
	if has_node("upgrade_ring") and TowerData.upgrade_mode == false:
		kill()

func shoot():	
		
		
		var projectile_inst = projectile.instantiate()
		projectile_inst.tower_t = tower_t
		projectile_inst.enemy = enemy # set the enemy var of the proj as the current target of the tower
		add_child(projectile_inst)
		

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


func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	pass # Replace with function body.


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	pass # Replace with function body.


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
	
	#save Tower and Tier Information in global so we know what towers upgrade into
	TowerData.last_selected = tower_t
	TowerData.last_selected_tier = Tier
	
	#Set upgrade mode to true so we know that a upgrade ring is active somewhere
	TowerData.upgrade_mode = true

func kill():
	if has_node("upgrade_ring"):
		get_node("upgrade_ring").free()
		print("kill up")
		pass

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
