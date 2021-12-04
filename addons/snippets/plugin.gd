tool
extends EditorPlugin

const api = preload("res://addons/snippets/api.tres")
var ui:Control

func _enter_tree():
	api.init(self)
	

#func _exit_tree():
#	remove_control_from_docks(ui)

func _input(event):
	if api:
		api._on_plugin_input(event)
