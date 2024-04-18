extends Node2D

# REMEMBER TO CONNECT ALL THE TOWERS TO THE LEVEL
# EXAMPLE
# $TowerPlot.connect("build_on", build_mode)
# $TowerPlot.connect("kill_child", kill_child)
# $TowerPlot2.connect("build_on", build_mode)
# $TowerPlot2.connect("kill_child", kill_child)

signal build_on
signal build_location
signal kill_child

@onready var anim = $animation

var location = Vector2()
var menu = false

var plot_name = self


func _process(delta):
	#code to stop summoing animation
	if LevelData.summoning == false:
		anim.play("idle")

	#if LevelData.build_block == true:
		#$animation/Button.disabled = true
	#else:
		#$animation/Button.disabled = false
		#
func _on_button_pressed():
	
	#turns off tower rotation targeting
	#LevelData.rotate_cone = false
	
	anim.play("play")
	
	if get_parent().is_built == true: # this is only done if the Buring_ring node is already in existance
	
		
			
		emit_signal("kill_child") # send command to delete build_ring node
		await get_tree().create_timer(.05).timeout # timer to give UI reactivity
		location = self.global_position # get location for where to spawn the child
		get_parent().b_location = location # send that info to the parent
		get_parent().build_m = true #Say that we are in building mode
		emit_signal("build_on") # send the command to create the Build_ring node
		
		#sets upgrade mode so that build_ring and upgrade ring are not out at the same time
		TowerData.upgrade_mode = false
		
		LevelData.summoning = true #code to allow for summoing animation
		anim.play("play")
		

		
	else: #this else statment is for creating the initial build_ring node
		
		
		location = self.global_position # get location for where to spawn the child
		get_parent().b_location = location # send that info to the parent
		get_parent().build_m = true #Say that we are in building mode
		emit_signal("build_on") # send the command to create the Build_ring node
		
		#sets upgrade mode so that build_ring and upgrade ring are not out at the same time
		TowerData.upgrade_mode = false
		LevelData.summoning = true #code to allow for summoing animation

