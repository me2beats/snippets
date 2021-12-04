static func find_node_by_class_path(node:Node, class_path:Array, inverted:= true)->Node:
	var res:Node

	var stack = []
	var depths = []

	var first = class_path[0]
	
	var children = node.get_children()
	if not inverted:
		children.invert()

	for c in children:
		if c.get_class() == first:
			stack.push_back(c)
			depths.push_back(0)

	if not stack: return res
	
	var max_ = class_path.size()-1

	while stack:
		var d = depths.pop_back()
		var n = stack.pop_back()

		if d>max_:
			continue
		if n.get_class() == class_path[d]:
			if d == max_:
				res = n
				return res

			var children_ = n.get_children()
			if not inverted:
				children_.invert()
			for c in children_:
				stack.push_back(c)
				depths.push_back(d+1)

	return res


static func find_child_by_type(node:Node, type):
	for child in node.get_children():
		if child is type:
			return child




static func get_main_screen(plugin:EditorPlugin)->int:
	var idx = -1
	var base:Panel = plugin.get_editor_interface().get_base_control()
	var button:ToolButton = find_node_by_class_path(
		base, ['VBoxContainer', 'HBoxContainer', 'HBoxContainer', 'ToolButton'], false
	)

	if not button: 
		return idx
	for b in button.get_parent().get_children():
		b = b as ToolButton
		if not b: continue
		if b.pressed:
			return b.get_index()
	return idx




##########
# REFACTOR THIS !
# too many functions..
##########


static func get_script_tab_container(scr_ed:ScriptEditor)->TabContainer:
	return find_node_by_class_path(scr_ed, ['VBoxContainer', 'HSplitContainer', 'TabContainer']) as TabContainer

static func get_script_text_editor(scr_ed:ScriptEditor, idx:int)->Container:
	var tab_cont = get_script_tab_container(scr_ed)
	return tab_cont.get_child(idx)

static func get_code_editor(scr_ed:ScriptEditor, idx:int)->Container:
	var scr_text_ed = get_script_text_editor(scr_ed, idx)
	return find_node_by_class_path(scr_text_ed, ['VSplitContainer', 'CodeTextEditor']) as Container

# some items can be null, this means not previously opened?
static func get_code_editors(scr_ed:ScriptEditor)->Array:
	var scr_tab_cont:TabContainer = get_script_tab_container(scr_ed)
	var result =[]
	#var code_ed_temp
	for s in scr_tab_cont.get_children():
		if ! s.get_child_count():
			result.push_back(null)
		else:
			result.push_back(find_node_by_class_path(s, ['VSplitContainer', 'CodeTextEditor']))
	return result

static func get_text_edit(scr_ed:ScriptEditor, idx:int)->TextEdit:
	var code_ed = get_code_editor(scr_ed, idx)
	return find_node_by_class_path(code_ed, ['TextEdit']) as TextEdit

static func get_current_script_idx(scr_ed:ScriptEditor)->int:
	var current = scr_ed.get_current_script()
	var opened = scr_ed.get_open_scripts()
	return opened.find(current)

static func get_current_text_ed(scr_ed:ScriptEditor)->TextEdit:
	var idx = get_current_script_idx(scr_ed)
	return get_text_edit(scr_ed, idx)





# not optimized
static func filter_array(arr:Array, filters:=[]):
	var result: = []
	for item in arr:
		var good = true
		for i in filters:
			var obj:Object = i[0]
			var method:String = i[1]
			var args:Array = i[2]
			if !obj.callv(method, [item]+args):
				good = false
				break
		if good:
			result.push_back(item)
	return result

