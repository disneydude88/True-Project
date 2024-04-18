extends AnimatedSprite2D



var speed = 750
var launch = false
var primed = false
var fall = false

var return_pos = Vector2.ZERO

var target_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#move up when projectile is spawned
	if launch == true:
		position.y -= speed * delta
		
	#move down after projectile reaches above the screen
	if fall == true:
		position.y += speed * delta
		primed = true
		
	#Move projectile to x coordinate of the target and swap to moving down
	if global_position.y < -50:
		global_position.x = target_position.x
		launch = false
		fall = true
		
	#make projectile explode once it reaches landing location
	if global_position.y >= target_position.y and primed:
		self.play("explode")
		$Fire.play()
		primed = false
		fall = false

#At end of animation send func to do damage
func _on_animation_finished():
	get_parent().shoot()
	await(get_tree().create_timer(2).timeout)
	self.queue_free()
