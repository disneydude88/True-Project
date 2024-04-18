extends CharacterBody2D

var projectile = preload("res://Scenes/Projectile/Lightning.tscn")

@onready var anim = $Obelisk_left
@onready var anim2 = $Obelisk_right
@onready var anim3 = $Gravity

var mainmenu = preload("res://Scenes/Core/MainMenu.tscn")

var hp
var alive = true
@onready var health_bar = get_node("hp_bar")

var enemy_array = []

var enemy_damage
var enemy_count = 0

var red = true
var fire = false

var top = false
var bot = true
var moving = true

var tower_t = "Crystal"
var enemy

signal game_over

func _ready():
	
	self.get_node("range/CollisionShape2D").get_shape().radius = 0.5 * TowerData.tower_data[tower_t]["range"]
	
	anim.play("idle")
	anim2.play("idle")
	anim3.play("default")
	
	hp = LevelData.crystal_hp
	
	health_bar.max_value = hp
	health_bar.value = hp
	
	pass



func _physics_process(delta):
	
		
	floating_object()

	if enemy_array.size() !=0:
		
		
		if red:
			
			red = false
			fire = true
			
			anim.play("attack")
			anim2.play("attack")
			$Charge.play()
			obelisk_animation()
			#attack speed is limited by animation speed
			await(get_tree().create_timer(TowerData.tower_data[tower_t]["rof"]).timeout) 
			red = true
	else:
		enemy = null
		anim.play("idle") #start idle animation
		anim2.play("idle")
		obelisk_animation()
		
		
		
func shoot():	
		
		var projectile_inst = projectile.instantiate()
		#projectile_inst.position =  Vector2(57.5,-58)
		projectile_inst.enemy = enemy # set the enemy var of the proj as the current target of the tower
		add_child(projectile_inst)
		
		
		if enemy != null:
			enemy.on_hit(TowerData.tower_data[tower_t]["damage"],TowerData.tower_data[tower_t]["damage_type"])
		
		
		
func _on_obelisk_right_animation_finished():
		if fire:
			select_enemy()
			shoot()
			$Charge.stop()
			$attack.play()
			fire = false


func obelisk_animation():
	if $Obelisk_left.animation == "attack":
		$Obelisk_left.position = Vector2(-60,-42)
	if $Obelisk_left.animation == "idle":
		$Obelisk_left.position = Vector2(-60,0)
		
		
	if $Obelisk_right.animation == "attack":
		$Obelisk_right.position = Vector2(60,-42)
	if $Obelisk_right.animation == "idle":
		$Obelisk_right.position = Vector2(60,0)
	

func floating_object():
	
	if moving:
		if bot:
			moving = false
			var tween = create_tween()
			tween.tween_property($Object, "position", Vector2(0,15), 3)
			await(get_tree().create_timer(3.15).timeout) 
			bot = false
			top = true
			moving = true
		if top:
			moving = false
			var tween = create_tween()
			tween.tween_property($Object, "position", Vector2(0,-15), 3)
			await(get_tree().create_timer(3.15).timeout)
			top = false
			bot = true
			moving = true
			
			
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


#take damage based on enemy attack stat
#change scene to main menu if the crystal dies
func on_hit(enemy_damage):
	
	hp -= enemy_damage
	health_bar.value = hp
	if enemy_damage == null:
		enemy_damage = 1
	if hp <= 0 and alive == true:
		LevelData.visible = true
		emit_signal("game_over")
		alive = false
		
func destroy():
	self.queue_free()


func _on_range_body_entered(body):
	enemy_array.append(body.get_parent())
	pass # Replace with function body.


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
	pass # Replace with function body.
