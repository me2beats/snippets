tool
extends LineEdit

func _ready():
	pass


func _on_visibility_changed():
	if not is_inside_tree(): return
	if visible:
		yield(get_tree(), "idle_frame")
		grab_focus()
#		grab_click_focus()


func _on_text_entered(new_text):
	var dialog = owner
#	dialog.hide()
#	dialog.emit_signal("confirmed")
	dialog.get_ok().emit_signal("pressed")
