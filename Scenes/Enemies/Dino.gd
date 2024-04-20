extends PathFollow2D

@onready var anim = $CharacterBody2D/AnimatedSprite2D
@onready var health_bar = get_node("hp_bar")


var attacking = false
var at_crystal

var enemy_type = "Dino"

var crystal
var path

var first = false

var paths = []
var rng = RandomNumberGenerator.new()
var swap = false
var already_entered = false

var time = 0.0


var speed_modifier = 1
var speed_storage

var debuff_time

var face_d
var xposition_last_frame = 0.0
var position_last_frame = Vector2()

var hp
var money


func _ready():
	
	hp = EnemyData.enemy_data["Dino"]["hp"]
	money = EnemyData.enemy_data["Dino"]["money"]
	
	health_bar.max_value = hp
	health_bar.value = hp
	
	anim.play("walk")
	
func _physics_process(delta):
	move(delta)
	 
	#print($Slow_timer.time_left)
	if $Slow_timer.time_left > 0:
		speed_modifier = speed_storage
		pass
		
	if $Slow_timer.time_left == 0:
		speed_modifier = 1
	
	
	#this section of code is to flip the sprite of the enemy if it is moving left or right
	var motion = position - position_last_frame
	
	if motion.length() > .0001:
		
		if position.x - xposition_last_frame > 0.0:
			$CharacterBody2D/AnimatedSprite2D.flip_h = false
			#print("right")
		else:
			$CharacterBody2D/AnimatedSprite2D.flip_h = true
			#print("left")
			pass
			
	position_last_frame = position
	
	xposition_last_frame = position.x
		
		
	# is swaping is true the dinos will move to new random path
	# Connected to the _on_swap_path_area_entered() func
	if swap:
		get_parent().remove_child(self) # remove from current path
		progress = 0 # set to beginning of new path
		path.add_child(self)# add to new path
		swap = false
		pass


# move enemy along path2d
func move(delta):
	set_progress(get_progress() + EnemyData.enemy_data["Dino"]["speed"] * speed_modifier * delta)
	time += .1
	
# enemy takes damage
#DINO takes higher magical dmg and less physical damage
func on_hit(damage,dmg_type):
	
	if dmg_type == "magical":
		hp -= damage * 2
		health_bar.value = hp
	if dmg_type == "physical":
		hp -= damage * .5
		health_bar.value = hp
	else:
		hp -= damage
		health_bar.value = hp
	if hp <= 0:
		WaveData.enemies_in_level -= 1
		destroy()

#kill enemy and give money for it
func destroy():
	
	LevelData.money += money
	attacking = false
	self.queue_free()
	
func speed_mod(timer, speed_mod):
	debuff_time = timer
	speed_storage = speed_mod
	$Slow_timer.start(debuff_time)
	
	
# deal damage to crystal based on enemy stats	
func attack_crystal():
	
		#loop to keep attacking while in crystal zone
		if crystal != null:
			while(attacking):
					if crystal.hp <= 0: # stops the dinos from attacking once crystal dies
						attacking = false
					anim.play("attack")
					crystal.on_hit(EnemyData.enemy_data["Dino"]["damage"])
					await(get_tree().create_timer(EnemyData.enemy_data["Dino"]["AttackSpd"])).timeout
					anim.play("idle")
				 # send the func to deal dmg
			

# get the crystal when the enemy reaches it send function to attck
func _on_area_2d_body_entered(body):
	crystal = body
	attacking = true
	attack_crystal()
	pass # Replace with function body.


# add path options to Dino
func _on_path_detect_area_entered(area):
	
	paths.append(area.get_parent())

func _on_swap_path_area_entered(area):
	if already_entered == false:
		path = paths[rng.randi_range(0,1)] # sets a random path
		swap = true
		already_entered = true
	
	
