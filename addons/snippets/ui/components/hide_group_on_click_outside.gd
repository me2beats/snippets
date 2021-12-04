tool
extends Resource

export (Array, String) var exception_groups
export var group_to_hide:String
export var margin:int=0

var node:Node

func init(node:Node):
	self.node = node

func _input(event:InputEventMouseButton):

#	if node.get_rect().has_point(event.position): return


	var tree = node.get_tree()
	
	for exc in exception_groups:
		var exc_nodes = tree.get_nodes_in_group(exc)

		for n in exc_nodes:
			if n.visible and n.get_rect().grow(margin).has_point(event.position): return

	var hideable_nodes = tree.get_nodes_in_group(group_to_hide)
	for _node in hideable_nodes:
		_node.visible = false
