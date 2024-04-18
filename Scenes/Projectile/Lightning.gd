extends Node2D


#video used for code refrence https://www.youtube.com/watch?v=QGReh8eF69w

var jaggedness_max = 10
var jaggedness_min = 5
var jaggedness_scale = 2
var bolt_length_factor = 50

var num_of_bisects = 5

var enemy

func _ready():

	$main_bolt.clear_points()
	
	$main_bolt.add_point(Vector2(0,0))
	for child in $main_bolt.get_children().size():
		$main_bolt.get_child(child).queue_free()
	
	create_lightning($main_bolt, to_local(enemy.position))
	
	var num_of_branches = 1 + randi_range(1,4)
	for branch in num_of_branches:
		create_branch($main_bolt, to_local(enemy.position))
		
	$AnimationPlayer.play("flash")
		
func create_lightning(bolt, target_pos):
	var length = target_pos - position
	bolt.clear_points()
	bolt.add_point(Vector2(0,0))
	bolt.add_point(length)
	
	var persistance = 1.0
	
	for bisect in num_of_bisects:
			var local_array = bolt.points
			for point in local_array.size() - 1:
				var start = local_array[point]
				var end = local_array[point + 1]
				var mid = (end - start) / 2
				var vec = (end - start).normalized()
				var normal = Vector2(vec.y, -vec.x)
				
				var rand_scale = randi_range(jaggedness_min, jaggedness_max) * random_pos_or_neg()
				var new_point = start  + mid + (rand_scale * jaggedness_scale * (length / bolt_length_factor) * persistance * normal)
				persistance *= 0.8
				
				bolt.add_point(new_point, (point * 2) + 1)
				
				#yield(get_tree().create_timer(0.3), "timeout")

func create_branch(branch_from_bolt, target_pos):
	var new_branch = Line2D.new()
	new_branch.default_color = branch_from_bolt.default_color
	new_branch.width = branch_from_bolt.width
	new_branch.texture = branch_from_bolt.texture
	new_branch.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	new_branch.position = branch_from_bolt.points[randi() % branch_from_bolt.points.size()]
	branch_from_bolt.add_child(new_branch)
	var new_target = target_pos - new_branch.position + Vector2(randf_range(0.0, 100.0), randf_range(0.0, 100.0))
	create_lightning(new_branch, new_target)
	
func random_pos_or_neg():
	var s = bool(randi() % 2)
	if s:
		return 1 
	else:
		return -1
