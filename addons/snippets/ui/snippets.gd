tool
extends Control

export (NodePath) var item_list_path
onready var item_list = get_node(item_list_path)

export (NodePath) var filter_path
onready var filter = get_node(filter_path)
