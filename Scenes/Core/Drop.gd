extends StaticBody2D

var slot
var full = false

func _ready():
	
	slot = get_name()
	
	if LevelData.is_dragging:
		visible = true
	else:
		visible = false
		


func _process(delta):
	
	#If build slot is full cannot add another tower to slot
	if full:
		$CollisionShape2D.disabled = true
	else:
		$CollisionShape2D.disabled = false

