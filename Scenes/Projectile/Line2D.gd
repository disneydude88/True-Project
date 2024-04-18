extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var tween = create_tween()
	#tween.tween_property(self, "points[1]", Vector2(500,0), 2)
		var tween = create_tween()
		tween.tween_method(self.set_point_position.bind(Vector2.ZERO), Vector2.ZERO, Vector2.ZERO, 2)
		pass
