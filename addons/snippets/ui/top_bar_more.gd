tool
extends MenuButton

onready var name_lineedit = $"Dialog/VBoxContainer/HBoxContainer/Name"

var api = preload("res://addons/snippets/api.tres")
#const Utils = preload("res://addons/snippets/utils.gd")

func _ready():
	get_popup().connect("index_pressed", self, "on_idx")

func on_idx(index:int):
	match index:
		0:
			print(" add from clipboard")
			var clipboard:String = OS.clipboard
			if not clipboard: return

			$Dialog.popup_centered()


func _on_confirmed():
	print ("confirmed")
	print(name_lineedit.text)
	api.add_item(name_lineedit.text, OS.clipboard)

	api.save_items()

	name_lineedit.clear()
	
	var itemlist:ItemList = owner.item_list
	itemlist.clear()
	itemlist.fill()
