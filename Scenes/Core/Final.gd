extends Node2D

signal upgrade
signal upgrade_2
signal upgrade_3
signal sell
signal kill
signal select_cone


var cone = false
var last_select

func _physics_process(delta):
	
	if cone:
		$Button4.visible = true
		pass
	#update the Cost of the upgrade/sell on the upgrade_ring for the current tower
	#$Upgrade_cost.text = LevelData.upgrade_cost_label
	#$sell_cost.text = LevelData.sell_cost_label

func _on_button_pressed():
	self.queue_free()
	
	pass # Replace with function body.


func _on_button_2_pressed():
	emit_signal("upgrade")



func _on_button_3_pressed():
	emit_signal("sell")
	pass # Replace with function body.+
	

# this button on ly active if cone is active
func _on_button_4_pressed():
	emit_signal("select_cone")
	self.queue_free()
	pass # Replace with function body.
