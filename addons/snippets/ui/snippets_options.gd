tool
extends MenuButton

var api = preload("res://addons/snippets/api.tres")

func _ready():

	get_popup().connect("id_pressed", self, "on_id_pressed")


func on_id_pressed(id:int):
	var popup: = get_popup()
	var idx = popup.get_item_index(id)
	var val: = popup.is_item_checked(idx)
	if popup.is_item_checkable(idx):
		popup.set_item_checked(idx, !val)
	
	match id:
		1:
			var window = api.ui
			window.head_visible = !window.head_visible
#			var head_parent = window.head.get_parent()
#			head_parent.visible = not head_parent.visible
	
