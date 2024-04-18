extends Node

var money = 999999
var crystal_hp = 100000

#var for keeping track of money related things
var money_label = str(money)
var upgrade_cost = 0
var upgrade_cost_label = str(upgrade_cost)
var sell_cost = 0
var sell_cost_label = str(sell_cost)

# vars for the towe plot animations
var visible = false
var summoning = false


var arrow_target

#var for dragging tower slots for assignment
var is_dragging = false


# variables for the World map and what level have been completed
var level_1_complete = false
var level_1_completed = false
var level_2_complete = false
var level_2_completed = false
var level_3_complete = false
var level_3_completed = false
var level_4_complete = false
var level_4_completed = false
var level_5_complete = false
var level_5_completed = false





var build_slot_1 = "Arrow"
var build_slot_2 = "Mortar"
var build_slot_3 = "Witch"
var build_slot_4 = "Wolf"

func _ready():
	pass
	#level_1_complete = false
	#level_1_completed = false
	#level_2_complete = false
	#level_2_completed = false
	#level_3_complete = false
	#level_3_completed = false
	#level_4_complete = false
	#level_4_completed = false
	#level_5_complete = false
	#level_5_completed = false

func _physics_process(delta):
	
	#update the player money label display
	money_label = str(money)
	
	upgrade_cost_label = str(upgrade_cost)
	sell_cost_label= str(sell_cost)
	
	pass
