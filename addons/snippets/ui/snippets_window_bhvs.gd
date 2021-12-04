tool
extends Node

const Utils: = preload("res://addons/snippets/utils.gd")
var api = preload("res://addons/snippets/api.tres")


export (NodePath) var snippets_path
onready var snippets = get_node(snippets_path)


func _on_Window_close_pressed():
	for node in get_tree().get_nodes_in_group("snippets_hideable"):
		node.hide()



func _on_Window_visibility_changed():
	var window = get_parent()
	if not window.visible:
		yield(get_tree(), "idle_frame")

		var scr_ed = api.script_editor
		var textedit: = Utils.get_current_text_ed(scr_ed)
		if not textedit: return
		textedit.grab_focus()

	else:
		if not snippets: return
		var filter:LineEdit = snippets.filter
		if not filter: return
		
		yield(get_tree(), "idle_frame")
		filter.grab_focus()		


func _on_head_released():
	return
	# no this is bad idea


func _input(event:InputEvent):
	if ! event is InputEventMouseButton or event.is_pressed(): return
	if not owner.visible: return
	var can_release_nodes = get_tree().get_nodes_in_group('snippets_mouse_released')
	for node in can_release_nodes:
#		if node.visible and node.get_rect().has_point(event.position):
		if node.visible and node.get_global_rect().has_point(event.global_position):
			
			yield(get_tree(), "idle_frame")

			var filter:LineEdit = snippets.filter
			filter.grab_focus()
	
			return
	
	
	
	
	
