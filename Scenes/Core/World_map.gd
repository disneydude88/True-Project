extends Node2D

var save_path = "user://variable.save"


func _ready():
	$BGmusic.play()
	# save what levels are complete
	#save()
	
	# load what levels are complete
	load_data() 

	# reveal dotlines depneding on level completion
	dot_line()


		
func save():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(LevelData.level_1_completed)
	file.store_var(LevelData.level_2_completed)
	file.store_var(LevelData.level_3_completed)
	file.store_var(LevelData.level_4_completed)
	file.store_var(LevelData.level_5_completed)
	
	
func load_data():

	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		LevelData.level_1_completed = file.get_var(LevelData.level_1_completed)
		LevelData.level_2_completed = file.get_var(LevelData.level_2_completed)
		LevelData.level_3_completed = file.get_var(LevelData.level_3_completed)
		LevelData.level_4_completed = file.get_var(LevelData.level_4_completed)
		LevelData.level_5_completed = file.get_var(LevelData.level_5_completed)
	else:
		print("no data")
		
# not used but used to COMPLETELY delte files
func delete_data():
	DirAccess.remove_absolute("user://variable.save")
	
func dot_line():
	#If level is has been completed before reavel the dot line immediatly
	if LevelData.level_1_completed:
		$Level_selection/LevelSelect/Dot_path.created = true
		
		#activate button to next level
		$Level_selection/LevelSelect2/level2.disabled = false
	
	#If level is has been completed for the first time reveal the line slowly
	if LevelData.level_1_complete:
		$Level_selection/LevelSelect/Dot_path.create = true
		await(get_tree().create_timer(3).timeout)
		LevelData.level_1_complete= false
		
		#activate button to next level
		$Level_selection/LevelSelect2/level2.disabled = false


	if LevelData.level_2_completed:
		$Level_selection/LevelSelect2/Dot_path2.created = true
		
	if LevelData.level_2_complete:
		$Level_selection/LevelSelect2/Dot_path2.create = true
		await(get_tree().create_timer(6).timeout)


#set level scene and starting money for player
func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
	
	#player's starting money for level
	LevelData.money = 3000
	pass # Replace with function body.


func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")
	
	#player's starting money for level
	LevelData.money = 5000
	pass # Replace with function body.



func _on_tower_select_pressed():
	get_tree().change_scene_to_file("res://Scenes/Core/MainMenu.tscn")
	pass # Replace with function body.

#reset all the level completed var to false
func _on_delete_pressed():
		LevelData.level_1_completed = false
		LevelData.level_2_completed = false
		LevelData.level_3_completed = false
		LevelData.level_4_completed = false
		LevelData.level_5_completed = false
		LevelData.level_1_complete = false
		LevelData.level_2_complete = false
		LevelData.level_3_complete = false
		LevelData.level_4_complete = false
		LevelData.level_5_complete = false
		save()
		get_tree().reload_current_scene()


func _on_b_gmusic_finished():
	$BGmusic2.play()
	pass # Replace with function body.
