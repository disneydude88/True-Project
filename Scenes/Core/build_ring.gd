extends Node2D

signal build_tower

var confirm = false
var confirm2 = false
var confirm3 = false
var confirm4 = false

var slot1
var slot2
var slot3
var slot4
  

func _ready():
	
	# set each build slot so that it is the player's selected towers
	slot1 = LevelData.build_slot_1
	slot2 = LevelData.build_slot_2
	slot3 = LevelData.build_slot_3
	slot4 = LevelData.build_slot_4
	select_icons()

func _physics_process(delta):


	
	#Turns off ofther checkmarks if another is selected
	if confirm == false:
		$Button/Sprite2D.visible = false
	if confirm2 == false:
		$Button2/Sprite2D.visible = false
	if confirm3 == false:
		$Button3/Sprite2D.visible = false
	if confirm4 == false:
		$Button4/Sprite2D.visible = false
	

#used to make sure the slots have the right PNG for the tower in that slot
func select_icons():
	if slot1 == "Arrow":
		$Button/Arrow.visible = true	
	if slot1 == "Mortar":
		$Button/Mortar.visible = true
	if slot1 == "Laser_t":
		$Button/Laser_t.visible = true
	if slot1 == "Cone":
		$Button/Cone.visible = true
	if slot1 == "Wolf":
		$Button/Wolf.visible = true
	if slot1 == "Witch":
		$Button/Witch.visible = true
	if slot1 == "Gun_Girl":
		$Button/Gun_Girl.visible = true
	if slot1 == "cloud":
		$Button/cloud.visible = true
		
	if slot2 == "Arrow":
		$Button2/Arrow.visible = true	
	if slot2 == "Mortar":
		$Button2/Mortar.visible = true
	if slot2 == "Laser_t":
		$Button2/Laser_t.visible = true
	if slot2 == "Cone":
		$Button2/Cone.visible = true
	if slot2 == "Wolf":
		$Button2/Wolf.visible = true
	if slot2 == "Witch":
		$Button2/Witch.visible = true
	if slot2 == "Gun_Girl":
		$Button2/Gun_Girl.visible = true
	if slot2 == "cloud":
		$Button/cloud.visible = true		
		
		
	if slot3 == "Arrow":
		$Button3/Arrow.visible = true	
	if slot3 == "Mortar":
		$Button3/Mortar.visible = true
	if slot3 == "Laser_t":
		$Button3/Laser_t.visible = true
	if slot3 == "Cone":
		$Button3/Cone.visible = true
	if slot3 == "Wolf":
		$Button3/Wolf.visible = true
	if slot3 == "Witch":
		$Button3/Witch.visible = true
	if slot3 == "Gun_Girl":
		$Button3/Gun_Girl.visible = true
	if slot3 == "cloud":
		$Button/cloud.visible = true
		
	if slot4 == "Arrow":
		$Button4/Arrow.visible = true	
	if slot4 == "Mortar":
		$Button4/Mortar.visible = true
	if slot4 == "Laser_t":
		$Button4/Laser_t.visible = true
	if slot4 == "Cone":
		$Button4/Cone.visible = true
	if slot4 == "Wolf":
		$Button4/Wolf.visible = true
	if slot4 == "Witch":
		$Button4/Witch.visible = true
	if slot4 == "Gun_Girl":
		$Button4/Gun_Girl.visible = true
	if slot4 == "cloud":
		$Button/cloud.visible = true
	

func _on_button_pressed():

	
	if confirm: #check if build confirm is on
		
		#set var so that we know what the last tower selected was
		TowerData.tower_type = slot1
		#Send signal to level to build tower
		emit_signal("build_tower")
		pass # Replace with function body.
	
	#reveal Confrim checkmark
	#disable other buttons
	else:
		$Button/Sprite2D.visible = true
		confirm = true
		confirm2 = false
		confirm3 = false
		confirm4 = false


func _on_button_2_pressed():
	
	if confirm2:
		
		TowerData.tower_type = slot2
		emit_signal("build_tower")
		pass # Replace with function body.
	
	else:
		$Button2/Sprite2D.visible = true
		confirm = false
		confirm2 = true
		confirm3 = false
		confirm4 = false

func _on_button_3_pressed():
	
	if confirm3:
		TowerData.tower_type = slot3
		emit_signal("build_tower")
		pass # Replace with function body.
	
	else:
		$Button3/Sprite2D.visible = true
		confirm = false
		confirm2 = false
		confirm3 = true
		confirm4 = false

func _on_button_4_pressed():
	
	if confirm4:
		
		TowerData.tower_type = slot4
		emit_signal("build_tower")
		pass # Replace with function body.
		
	else:
		$Button4/Sprite2D.visible = true
		confirm = false
		confirm2 = false
		confirm3 = false
		confirm4 = true
