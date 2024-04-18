extends Node

var tower_type
var upgrade_tower

var last_selected
var last_selected_tier

var upgrade_mode = false

var tower_data = { 
	
	
	"Crystal": {
	"damage": 500,
	"damage_type": "magic",
	"rof": 4,
	"range": 2000,
	"up_cost": 200,
	"cost": 100,
	"sell": 100
	
	 },
	
	"Gun_Girl": {
	"damage": 50,
	"damage_type": "physical",
	"rof": .25,
	"range": 750,
	"up_cost": 200,
	"cost": 100,
	"sell": 100
	
	 },
	
	"Witch": {
	"damage": 500,
	"damage_type": "magic",
	"rof": 1,
	"range": 500,
	"cost": 100,
	"up_cost": 200,
	"sell": 100
	 },
	
	"Witch2": {
	"damage": 2000,
	"damage_type": "magic",
	"rof":.8,
	"range": 1000,
	"up_cost": 300,
	"sell": 200
	 },
	
	"Witch3": {
	"damage": 1000,
	"damage_type": "magic",
	"rof": .7,
	"range": 1000,
	"up_cost": 500,
	"sell": 250
	 },
	
	"Wolf": {
	"damage": 1500,
	"damage_type": "physical",
	"rof": 1,
	"range": 1000,
	"cost": 200,
	"up_cost": 500,
	"sell": 250
	 },
	
	"Cone": {
	"damage": 25,
	"damage_type": "magic",
	"rod": .25,
	"rof": 2,
	"range": 1000,
	"cost": 200,
	"up_cost": 500,
	"sell": 250
	 },
	
	"Arrow": {
	"damage": 500,
	"damage_type": "physical",
	"rof": .75,
	"range": 800,
	"cost": 200,
	"up_cost": 500,
	"sell": 250
	 },
	
	
	"Mortar": {
	"damage": 2000,
	"damage_type": "physical",
	"rof": 2,
	"cost": 200,
	"up_cost": 500,
	"sell": 250
	 },
	
	
	"Laser_t": {
	"damage": 5,
	"range": 800,
	"damage_type": "physical",
	"rof": .5,
	"cost": 200,
	"up_cost": 500,
	"sell": 250
	 }
	
}

