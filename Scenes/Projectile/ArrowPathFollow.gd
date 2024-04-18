extends PathFollow2D

var speed = 800
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


 #Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)

func move(delta):
	
	#move arrow along path
	set_progress(get_progress() + speed * delta)
	
	#damage enemy once arrow completes path
	if progress_ratio == 1:
		get_parent().on_hit()
		
