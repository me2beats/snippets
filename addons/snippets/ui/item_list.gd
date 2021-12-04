tool
extends Tree

var api = preload("res://addons/snippets/api.tres")
const Utils = preload("res://addons/snippets/utils.gd")

#func _ready():
#	fill()

# _ready() is bad because it's auto called in tool mode
# instead, let's call init() manually somewhere in plugin.gd etc
#func init():
#	fill()

# another way is to do some checks in _ready() first.
# maybe owner.get_parent() is Viewport ?
# but some other checks needed when itemlist is in a scene itself
func _ready():	
	if owner.get_parent() is Viewport:
		return
	yield(get_tree(),"idle_frame")
	clear()
	fill()
	
	connect("gui_input", self, "on_gui")
	connect("mouse_exited", self, "on_mouse_exited")

func on_mouse_exited():	
	return



func on_gui(event:InputEvent):
	
	return
	
	if event is InputEventKey and Input.is_key_pressed(KEY_ESCAPE):
		var snippet = api.snippet_preview
#		if snippet and snippet.visible:
		if snippet and snippet.get_parent().visible:
#			snippet.hide()
			snippet.get_parent().hide()
			accept_event()


func fill():
	var items = api.items
	
	var filtered_items = Utils.filter_array(items.keys(), filters)
	
	var root: = create_item()
	

#	for snippet_name in items:
	for snippet_name in filtered_items:
		var item = create_item(root)
		item.set_text(0,  snippet_name)
		item.set_metadata(0, items[snippet_name])


# move to api?
#var filters = [[self, 'has_substring', ["a"]]]
var filters = []

func has_substring(text, substring:String):
	return substring in text



func _on_item_activated():
	var textedit: = Utils.get_current_text_ed(api.script_editor)
	if not textedit:
		push_warning("Script Editor should be opened")
		return
	if not Utils.get_main_screen(api.plugin) == 2:
		push_warning("Script Editor should be opened")
		return

	var item = get_selected()
	var snippet_text = item.get_metadata(0)

	var snippet_preview = api.snippet_preview
	api.add_text_at_caret(snippet_text)
#	snippet_preview.hide()


	owner.get_parent().owner.hide()
	yield(get_tree(), "idle_frame")
	snippet_preview.get_parent().hide()


func _on_item_selected():
	var item = get_selected()
	
	if item == get_root():
		item.deselect(0)
		return

	var preview_panel = api.preview_panel
	if not preview_panel.get_child_count():
		api.add_preview()

#	snippet.visible = true
	preview_panel.visible = true
#	snippet.rect_global_position = get_global_mouse_position()+Vector2(30, 0)
#	snippet.get_parent().rect_global_position.x = rect_global_position.x+rect_size.x
	var snippet = api.snippet_preview

	
	var snippet_text = item.get_metadata(0)
	snippet.text = snippet_text

	owner.filter.grab_focus()


func _exit_tree():
	return



func _on_custom_tooltip_requested():
	return

	if !owner.visible: return

	var item_at_mouse:TreeItem = get_item_at_position(get_local_mouse_position())
	if !item_at_mouse: return
	
	var snippet_text = item_at_mouse.get_metadata(0)
	
	var preview_panel = api.preview_panel
	if not preview_panel.get_child_count():
		api.add_preview()

	preview_panel.visible = true
	var snippet = api.snippet_preview

#	snippet.get_parent().rect_global_position = get_global_mouse_position()+Vector2(30, 0)
#	snippet.get_parent().rect_global_position.x = rect_global_position.x+rect_size.x

	snippet.text = snippet_text


func _on_item_rmb_selected(at_position):
	$ContextMenu.popup(Rect2(get_global_mouse_position(), Vector2(200, 400)))





func _on_ContextMenu_index_pressed(index):
	match index:
		0:
			var sel_item: = get_selected()
			
#			var sel_items = get_selected_items()
#			if not sel_items: return
#			var snippet_id:String = get_item_text(sel_items[0])
			api.remove_item(sel_item.get_text(0))
			api.save_items()
	
			clear()
			fill()


func _on_multi_selected(item: TreeItem, column: int, selected: bool):
	print("multiselected")
	var snippet = api.snippet_preview
#	snippet.visible = true
	snippet.get_parent().visible = true

#	snippet.get_parent().rect_global_position = get_global_mouse_position()+Vector2(30, 0)
#	snippet.get_parent().rect_global_position.x = rect_global_position.x+rect_size.x
	var snippet_text = item.get_metadata(0)
#	var snippet_text = get_item_metadata(index)
	snippet.text = snippet_text


func _on_nothing_selected():
	owner.filter.grab_focus()
