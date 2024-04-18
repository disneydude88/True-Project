extends Node2D

var save_path = "user://variable.save"

var create = false
var created = false

func _physics_process(delta):
	
	#Makes the Red dot line appear instantly so long as it has been created before
	if created:
		if has_node("Red1"):
			$Red1.scale = Vector2(.015,.015)
		if has_node("Red2"):
			$Red2.scale = Vector2(.015,.015)
		if has_node("Red3"):
			$Red3.scale = Vector2(.015,.015)
		if has_node("Red4"):
			$Red4.scale = Vector2(.015,.015) 
		if has_node("Red5"):
			$Red5.scale = Vector2(.015,.015)
		if has_node("Red6"):
			$Red6.scale = Vector2(.015,.015)
		if has_node("Red7"):
			$Red7.scale = Vector2(.015,.015)
		if has_node("Red8"):
			$Red8.scale = Vector2(.015,.015)
		if has_node("Red9"):
			$Red9.scale = Vector2(.015,.015)
		if has_node("Red10"):
			$Red10.scale = Vector2(.015,.015)
		if has_node("Red11"):
			$Red11.scale = Vector2(.015,.015)
		if has_node("Red12"):
			$Red12.scale = Vector2(.015,.015) 
		if has_node("Red13"):
			$Red13.scale = Vector2(.015,.015)
		if has_node("Red14"):
			$Red14.scale = Vector2(.015,.015)
		if has_node("Red15"):
			$Red15.scale = Vector2(.015,.015)

	#Slowly have the red dot line appear after a level is beaten.
	if create:
		if has_node("Red1"):
			var tween = create_tween()
			tween.tween_property($Red1, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red2"):
			var tween2 = create_tween()
			tween2.tween_property($Red2, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red3"):
			var tween3 = create_tween()
			tween3.tween_property($Red3, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red4"):
			var tween4 = create_tween()
			tween4.tween_property($Red4, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red5"):
			var tween5 = create_tween()
			tween5.tween_property($Red5, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red6"):
			var tween6 = create_tween()
			tween6.tween_property($Red6, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red7"):
			var tween7 = create_tween()
			tween7.tween_property($Red7, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red8"):
			var tween8 = create_tween()
			tween8.tween_property($Red8, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red9"):
			var tween9 = create_tween()
			tween9.tween_property($Red9, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red10"):
			var tween10 = create_tween()
			tween10.tween_property($Red10, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red11"):
			var tween11 = create_tween()
			tween11.tween_property($Red11, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red12"):
			var tween12 = create_tween()
			tween12.tween_property($Red12, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red13"):
			var tween13 = create_tween()
			tween13.tween_property($Red13, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red14"):
			var tween14 = create_tween()
			tween14.tween_property($Red14, "scale", Vector2(.015,.015), .24)
			await(get_tree().create_timer(.25).timeout) 
		if has_node("Red15"):
			var tween15 = create_tween()
			tween15.tween_property($Red15, "scale", Vector2(.03,.03), .24)
		
		#Set the level as complted for save records
		LevelData.level_2_completed = true
		#save the records
		$"../../..".save()
