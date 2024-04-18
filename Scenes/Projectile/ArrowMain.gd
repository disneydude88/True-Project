extends Node2D
# THIS NODE 
# exists so that the path 2d can use local coordinates rather than global

var b_location #= Vector2(0),0
var enemy 
var tower_t


func _ready():
	
	
	
	
	position = b_location
	
	#send enemy and tower information to projectile
	$Path2D.enemy = enemy
	$Path2D.tower_t = tower_t
