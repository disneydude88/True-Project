extends Node2D

var save_path = "user://variable.save"


var child_alive = false
var b_location
var t_location
var delete_c = false
var build_m = false
var b_ring = preload("res://Scenes/Core/build_ring.tscn")
var u_ring = preload("res://Scenes/Core/upgrade_ring.tscn")



var current_wave = 0
var enemies_in_wave = 0

var is_built = false
var is_built_u = false

var build_u = false

var enemy_array = []

var enemy
var money


#level complete variables.






func _ready():
	
	$CrystalCore.connect("game_over", game_over)
	#connect all the Tower plots to the level
	connection()

	#start the enemies
	start_next_wave()
	
#end the game and send back to main menu
func game_over():
		
		$Fail.visible = true
		await(get_tree().create_timer(5)).timeout
		#$CrystalCore.destroy()
		
# connect the towerplots to the level
func connection():
		#Connections to TowerPlot Buttons MUST BE MADE FOR EACH NEW TOWER PLOT
	if has_node("TowerPlot"):
		$TowerPlot.connect("build_on", build_mode)
		$TowerPlot.connect("kill_child", kill)
	if has_node("TowerPlot2"):
		$TowerPlot2.connect("build_on", build_mode)
		$TowerPlot2.connect("kill_child", kill)
	if has_node("TowerPlot3"):
		$TowerPlot3.connect("build_on", build_mode)
		$TowerPlot3.connect("kill_child", kill)
	if has_node("TowerPlot4"):
		$TowerPlot4.connect("build_on", build_mode)
		$TowerPlot4.connect("kill_child", kill)
	if has_node("TowerPlot5"):
		$TowerPlot5.connect("build_on", build_mode)
		$TowerPlot5.connect("kill_child", kill)
	if has_node("TowerPlot6"):
		$TowerPlot6.connect("build_on", build_mode)
		$TowerPlot6.connect("kill_child", kill)
	if has_node("TowerPlot7"):
		$TowerPlot7.connect("build_on", build_mode)
		$TowerPlot7.connect("kill_child", kill)
	if has_node("TowerPlot8"):
		$TowerPlot8.connect("build_on", build_mode)
		$TowerPlot8.connect("kill_child", kill)
	if has_node("TowerPlot9"):
		$TowerPlot9.connect("build_on", build_mode)
		$TowerPlot9.connect("kill_child", kill)
	if has_node("TowerPlot10"):
		$TowerPlot10.connect("build_on", build_mode)
		$TowerPlot10.connect("kill_child", kill)
	if has_node("TowerPlot11"):
		$TowerPlot11.connect("build_on", build_mode)
		$TowerPlot11.connect("kill_child", kill)
	if has_node("TowerPlot12"):
		$TowerPlot12.connect("build_on", build_mode)
		$TowerPlot12.connect("kill_child", kill)
	if has_node("TowerPlot13"):
		$TowerPlot13.connect("build_on", build_mode)
		$TowerPlot13.connect("kill_child", kill)
	if has_node("TowerPlot14"):
		$TowerPlot14.connect("build_on", build_mode)
		$TowerPlot14.connect("kill_child", kill)
	if has_node("TowerPlot15"):
		$TowerPlot15.connect("build_on", build_mode)
		$TowerPlot15.connect("kill_child", kill)
	if has_node("TowerPlot16"):
		$TowerPlot16.connect("build_on", build_mode)
		$TowerPlot16.connect("kill_child", kill)
	if has_node("TowerPlot17"):
		$TowerPlot17.connect("build_on", build_mode)
		$TowerPlot17.connect("kill_child", kill)
	if has_node("TowerPlot18"):
		$TowerPlot18.connect("build_on", build_mode)
		$TowerPlot18.connect("kill_child", kill)
	if has_node("TowerPlot19"):
		$TowerPlot19.connect("build_on", build_mode)
		$TowerPlot19.connect("kill_child", kill)
	if has_node("TowerPlot20"):
		$TowerPlot20.connect("build_on", build_mode)
		$TowerPlot20.connect("kill_child", kill)
		
	
	
	#$TowerPlot2.connect("build_on", build_mode)
	#$TowerPlot2.connect("kill_child", kill)
	#$TowerPlot3.connect("build_on", build_mode)
	#$TowerPlot3.connect("kill_child", kill)
	#$TowerPlot4.connect("build_on", build_mode)
	#$TowerPlot4.connect("kill_child", kill)
	#$TowerPlot5.connect("build_on", build_mode)
	#$TowerPlot5.connect("kill_child", kill)
	#$TowerPlot6.connect("build_on", build_mode)
	#$TowerPlot6.connect("kill_child", kill)
	#$TowerPlot7.connect("build_on", build_mode)
	#$TowerPlot7.connect("kill_child", kill)
	#$TowerPlot8.connect("build_on", build_mode)
	#$TowerPlot8.connect("kill_child", kill)
	#$TowerPlot9.connect("build_on", build_mode)
	#$TowerPlot9.connect("kill_child", kill)
	#$TowerPlot10.connect("build_on", build_mode)
	#$TowerPlot10.connect("kill_child", kill)
	#$TowerPlot11.connect("build_on", build_mode)
	#$TowerPlot11.connect("kill_child", kill)
	#$TowerPlot12.connect("build_on", build_mode)
	#$TowerPlot12.connect("kill_child", kill)
	
	
func _physics_process(delta):

	if WaveData.enemies_in_level == 0 and current_wave < 15:
		start_next_wave()
	if WaveData.enemies_in_level == 0 and current_wave == 15:
		$Win.visible = true
		LevelData.level_2_complete = true
		#save()
		

		
	# contantly check if there  is a build_ring node to delete if conditions met
	if has_node("build_ring") == true and build_m == false:
		get_node("build_ring").free()
		child_alive = false
		pass
		
	if has_node("build_ring") == true and TowerData.upgrade_mode == true:
		get_node("build_ring").free()
		pass
	
	#updates the Player's money amount
	$UI/Hud/InfoBar/HBoxContainer/money.text = LevelData.money_label
	money = LevelData.money
	
	$UI/Hud/InfoBar2/HBoxContainer/WaveAmount.text = str(current_wave)
	

	#checks if build_ring node exists
	is_built = (has_node("build_ring"))
	
	
#func to delete build_ring node
func kill():
	if has_node("build_ring"):
		get_node("build_ring").free()
		
		LevelData.summoning = false #code to stop the summoning animation



#build Tower
func build_tower():
	#print(TowerData.tower_type)
	LevelData.money = LevelData.money - TowerData.tower_data[TowerData.tower_type]["cost"]# subtract cost of tower from playuer's money
	if LevelData.money > 0:
		var instance1 = load("res://Scenes/Towers/" + TowerData.tower_type + ".tscn").instantiate()
		instance1.set_position(b_location)
		add_child(instance1)
		build_m = false
		
		LevelData.summoning = false #code to allow for summoing animation
	else:
		LevelData.money = LevelData.money + TowerData.tower_data[TowerData.tower_type]["cost"] # add back money if player didnt have enough to but tower
		print("not enough money")
		pass
	#code to stop summoing animation
	

#func to create the build_ring
func build_mode():
	
	#will Only create build_ring node if in build mode
	if build_m == true:
		var instance = b_ring.instantiate()
		instance.set_position(b_location)
		add_child(instance)
		$build_ring.connect("build_tower", build_tower) # connect Build_ring buttons to Level
		build_m = true
		

#This is where you create what enemies will spawn
func retrieve_wave_data():
	
	current_wave += 1 #change what wave we are on
	var wave_data = WaveData.wave_data[get_name()][current_wave]
	enemies_in_wave = wave_data.size() #detect how many enemies are in current wave
	WaveData.enemies_in_level = wave_data.size()
	return wave_data
# loop through wave data and retrieve wave data and spawn the enemies on the level
func spawn_enemies(wave_data):
	
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instantiate()
		get_node("Path2D").add_child(new_enemy, true)
		await (get_tree().create_timer(i[1])).timeout


# func to start the wave that we have. 	
func start_next_wave():
	var wave_data = retrieve_wave_data()
	await (get_tree().create_timer(0.2)).timeout    
	spawn_enemies(wave_data)


# func to delete build_ring node if random map stuff is clicked
func _unhandled_input(event):
	if event.is_action_released("left_click") and has_node("build_ring"):
		get_node("build_ring").free()
		build_m = false
		
		LevelData.summoning = false #code to stop summoning animation
		#print("unhandled kill")
		


#spawn enemies for DEBUG
func _on_button_pressed():
	var wave_data = retrieve_wave_data()
	await (get_tree().create_timer(0.2)).timeout    
	spawn_enemies(wave_data)
	current_wave = 1

#return to main menu
func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Core/MainMenu.tscn")
	
	
	
	
func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(LevelData.level_2_complete)



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/Core/World_map.tscn")
	
