extends Path2D

var midpoint
var b_location = Vector2(0,0)
var enemy 
var tower_t

var last_know_position
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#create intitial path points
	self.curve.add_point(Vector2(0,0))
	self.curve.add_point(Vector2(50,50))

func _process(delta):
	
		
	#set first point at tower location
	self.curve.set_point_position(0,Vector2(0,0))
	
	#So long as the enemy exists do the below
	if enemy != null:
		
		#checks if the enemy is to the right
		if to_local(enemy.position).x >= b_location.x:
			
			var outX = to_local(enemy.position).x/2 #find the midpoint to curve too
			
			self.curve.set_point_out(0,Vector2(outX, -outX))
			self.curve.set_point_in(1,Vector2(-outX,-outX))
			
			# set position for the where the enemy is. Converts from enemies global coordinates to local
			self.curve.set_point_position(1, to_local(enemy.position))  
			
			#print("right")
			
		#checks if the enemy is to the left
		if to_local(enemy.position).x < b_location.x:
			var outX = to_local(enemy.position).x/2 #find the midpoint to curve too
			
			self.curve.set_point_out(0,Vector2(outX, outX))
			self.curve.set_point_in(1,Vector2(-outX, outX))
			
			# set position for the where the enemy is. Converts from enemies global coordinates to local
			self.curve.set_point_position(1, to_local(enemy.position))
			#print("left")
		
		last_know_position  = to_local(enemy.position)
		
	else:
		#if enemy dies mid flight head to its last know spot
		curve.set_point_position(1, Vector2(last_know_position))
		pass
	
func on_hit():
		if enemy != null:
			enemy.on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
			get_parent().queue_free()
		else:
			get_parent().queue_free()

		
	#if enemy != null:
		#
		#
		#midpoint = (enemy.position.x + b_location.x)/2
		#
#
		## so long as the enemy is above the turret change points appropriatly
		#if enemy.position.y < b_location.y:
			#curve.set_point_position(1, Vector2(midpoint, (enemy.position.y - 40) ) )
			##print("up")
			#
		## so long as the enemy is below the turret change points appropriatly	
		#else:
			#curve.set_point_position(1, Vector2(midpoint, (b_location.y - 40) ) )
			##print("down")
			#pass
		#
		## so long as the enemy is to the left of the turret change points appropriatly
		#if enemy.position.x < b_location.x:
			#
			#if b_location.x - enemy.position.x < 250 and b_location.x - enemy.position.x > 100 :
				#curve.set_point_out(1,Vector2(-80,-30))
				##print("far left")
			#
			#
			#elif b_location.x - enemy.position.x < 100 :
				#curve.set_point_out(1,Vector2(-10,-100))
			##	print("close left")
				#
			#elif  b_location.x - enemy.position.x > 250:
				#curve.set_point_out(1,Vector2(-125,-100))
				##print("farer left")
				#
		## so long as the enemy is right of the turret change points appropriatly
		#else:
			#
			#if enemy.position.x - b_location.x < 250 and enemy.position.x - b_location.x > 100 :
				#curve.set_point_out(1,Vector2(50, -150))
				##print("far right")
			#
			#
			#elif enemy.position.x - b_location.x < 100 :
				#curve.set_point_out(1,Vector2(10,-100))
				##print("close right")
				#
			#elif  enemy.position.x - b_location.x > 250:
				#curve.set_point_out(1,Vector2(100,-100))
				##print("farer right")
				#
				#
			#
		#curve.set_point_position(2, Vector2(enemy.position))
		#
		#last_know_position  = enemy.position
		#
	#else:
		##if enemy dies mid flight head to its last know spot
		#curve.set_point_position(2, Vector2(last_know_position))
		#pass
	#
	##damage enemy and delete path
