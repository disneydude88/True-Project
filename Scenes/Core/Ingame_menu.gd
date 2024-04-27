extends Node2D

@onready var Master_bus = AudioServer.get_bus_index("Master")
@onready var Music_bus = AudioServer.get_bus_index("Music")
@onready var SFX_bus = AudioServer.get_bus_index("SFX")


func _on_music_slider_value_changed(value):
	
	AudioServer.set_bus_volume_db(Music_bus, linear_to_db(value))
	AudioServer.set_bus_mute(Music_bus, value < .05)
	pass # Replace with function body.


func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(Master_bus, linear_to_db(value))
	AudioServer.set_bus_mute(Master_bus, value < .05)
	pass # Replace with function body.


func _on_button_pressed():
	$".".visible = false
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_bus, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_bus, value < .05)
	pass # Replace with function body.


func _on_area_2d_mouse_entered():
	$exit.scale = Vector2(1.05,1.05)
	pass # Replace with function body.


func _on_area_2d_mouse_exited():
	$exit.scale = Vector2(1,1)
	pass # Replace with function body.
