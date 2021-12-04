tool
extends Node

export var group:String


func _ready():
	if not group: return
	var parent = get_parent()
	parent = parent as MenuButton
	if not parent: return
	
	parent.get_popup().add_to_group(group)
