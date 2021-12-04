tool
extends Node

#var signal_name: = 'custom_tooltip_requested'
signal custom_tooltip_requested

export var wait_time: = 0.5

var is_mouse_entered: = false


func _enter_tree():
	if !get_parent() is Control:
		if !get_parent() is Viewport:
			push_warning("The Component works only as a parent of a Control")
		if !Engine.is_editor_hint():
			get_tree().quit()
		return

	var par = get_parent()
	if !par.is_connected("gui_input", self,  "on_parent_gui"):
		par.connect("gui_input", self,  "on_parent_gui")

	if !par.is_connected("mouse_exited", self, "on_parent_mouse_exited"):
		par.connect("mouse_exited", self, "on_parent_mouse_exited")

#	par.add_user_signal(signal_name)
	
	$Timer.wait_time = wait_time

	update_configuration_warning()

func _exit_tree():
	if !get_parent() is Control:
		return

	var par = get_parent()
	if par.is_connected("gui_input", self,  "on_parent_gui"):
		par.disconnect("gui_input", self,  "on_parent_gui")
	if par.is_connected("mouse_exited", self, "on_parent_mouse_exited"):
		par.disconnect("mouse_exited", self, "on_parent_mouse_exited")



func on_parent_mouse_exited():
	is_mouse_entered = false

func on_parent_gui(event:InputEvent):
	
	is_mouse_entered = true
	if event is InputEventMouseMotion and not event.button_mask:
		$Timer.start()



func _on_Timer_timeout():
	if not is_mouse_entered: return
	var par = get_parent()
	emit_signal('custom_tooltip_requested')

#	print(signal_name)


func _get_configuration_warning():
	if get_parent() is Control:	return ""
	if Engine.is_editor_hint() and get_parent() is Viewport: return ""
	return "The Component should be a child of a Control"
