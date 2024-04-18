extends Node2D


func _ready():
	$BGmusic.play()
	pass
	
func _process(delta):
	
	pass

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Core/World_map.tscn")
	


func _on_texture_button_3_pressed():
	get_tree().quit()



func _on_b_gmusic_finished():
	$BGmusic2.play()
	pass # Replace with function body.
