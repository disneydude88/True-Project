extends Node2D

var draggable = false
var is_inside_dropable = false
var body_ref
var offsett: Vector2
var start_pos
var tower_type
var selected = false

# here is the video for the drag and drop https://www.youtube.com/watch?v=uhgswVkYp0o


func _ready():
	
	start_pos = global_position
	tower_type = get_name()

func _process(delta):
	
	
	$Sprite2D/Label.text = get_name()
	
	
	if draggable:
		
		if Input.is_action_just_pressed("left_click"):
			
			if body_ref != null:
				body_ref.full = false
			
			offsett = get_global_mouse_position() - global_position
			LevelData.is_dragging = true
		
		if Input.is_action_pressed("left_click"):
			global_position = get_global_mouse_position()
			
		elif Input.is_action_just_released("left_click"):
			
			LevelData.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				tween.tween_property(self,"position", body_ref.position, .2).set_ease(Tween.EASE_OUT)
				
				#sets the Build slot as filled
				body_ref.full = true
				
				#Sets the proper build slot to tower_type based on which slot it is in
				if body_ref.slot == "Drop1":
					LevelData.build_slot_1 = tower_type
				if body_ref.slot == "Drop2":
					LevelData.build_slot_2 = tower_type
				if body_ref.slot == "Drop3":
					LevelData.build_slot_3 = tower_type
				if body_ref.slot == "Drop4":
					LevelData.build_slot_4 = tower_type
			else:
				tween.tween_property(self,"global_position", start_pos, .2).set_ease(Tween.EASE_OUT)
	



func _on_area_2d_body_entered(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body_ref = body
		

func _on_area_2d_body_exited(body):
	if body.is_in_group('dropable'):
		is_inside_dropable = false
		

#makes selection bigger for reactivly
func _on_area_2d_mouse_entered():
	if not LevelData.is_dragging:
		draggable = true
		scale = Vector2(1.05,1.05)

#makes selection smaller for reactivly
func _on_area_2d_mouse_exited():
	if not LevelData.is_dragging:
			draggable = false
			scale = Vector2(1,1)
