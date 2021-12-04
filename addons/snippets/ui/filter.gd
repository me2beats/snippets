tool
extends LineEdit



func _input(event):
	
	if !has_focus(): return

	if event.is_action("ui_down")\
	or event.is_action("ui_up")\
	or (event.is_action("ui_accept") and not event.is_action("ui_select"))\
	or event.is_action("ui_page_down")\
	or event.is_action("ui_page_up"):

		accept_event()

		var tree:Tree = owner.item_list
		tree.grab_focus()
		Input.parse_input_event(event)
		yield(get_tree(), "idle_frame")		
		grab_focus()


func _on_text_changed(new_text):
	var tree:Tree = owner.item_list
	if text:
		tree.filters = [[tree, 'has_substring', [new_text]]]
	else:
		tree.filters = []
	tree.clear()
	tree.fill()
