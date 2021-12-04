tool
extends Button

#refactor later
onready var name_lineedit = $"Dialog/VBoxContainer/HBoxContainer/Name"

var api = preload("res://addons/snippets/api.tres")
const Utils = preload("res://addons/snippets/utils.gd")

func _pressed():
	var textedit: = Utils.get_current_text_ed(api.script_editor)
	if not textedit or not Utils.get_main_screen(api.plugin) == 2:
		push_warning("Script Editor should be opened")
		return
	var selection_text = textedit.get_selection_text()
	if not selection_text:
		push_warning("Nothing to add. Some text should be selected in Script Editor")
		return
	$Dialog.popup_centered()

func _on_confirmed():
	api.add_item(name_lineedit.text, api.get_script_editor_selected_text())

	api.save_items()

	name_lineedit.clear()
	
	var itemlist:Tree = $"../../../ItemList"
	itemlist.clear()
	itemlist.fill()
	
	
	# select recently added
