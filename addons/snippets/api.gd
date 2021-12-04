tool
extends Resource

const Utils: = preload("res://addons/snippets/utils.gd")

var config_path:String
#= "res://addons/snippets/items.cfg"

const code_highlight: = preload("code_highlight.tres")

var ui:Control

#export var preview_font_color:Color
var preview_font_color:=Color.white

var plugin:EditorPlugin

var config: = ConfigFile.new()

var items: = {}

var script_editor:ScriptEditor

var preview_panel: = PanelContainer.new()
var snippet_preview:TextEdit


export var ui_window_rect:Rect2


func init(plugin:EditorPlugin):
	
	
	self.plugin = plugin
	init_config()


	items.clear()
	items = get_items_from_config()
	script_editor = plugin.get_editor_interface().get_script_editor()

	var base = plugin.get_editor_interface().get_base_control()
	ui = load("res://addons/snippets/ui/snippets_window1.tscn").instance()
	ui.visible = false
	base.add_child(ui)


	# add preview panel
	
#	base.add_child(snippet_preview)
	preview_panel.add_to_group("snippets_hideable")
	if not preview_panel.get_parent():
		base.add_child(preview_panel)

	preview_panel.set("custom_styles/panel", preload("res://addons/snippets/ui/snippets.tres"))
	preview_panel.visible = false

#	preview_panel.rect_size = snippet_preview.rect_size

	plugin.connect("tree_exited",  self, "_on_plugin_exit")


	# add preview (try)
	add_preview()
	
	ui.connect("item_rect_changed", self, "on_ui_rect_changed")


func init_config():
	var settings_dir = plugin.get_editor_interface().get_editor_settings().get_settings_dir()
	var me2beats_data_dir = settings_dir.plus_file("me2beats")
	var snippets_dir = me2beats_data_dir.plus_file("snippets")
	var directory: = Directory.new()
	var config_exist = true
	if !directory.dir_exists(snippets_dir):
		config_exist = false
		var error = directory.make_dir_recursive(snippets_dir)
		if error:
			push_error("Can't create snippets dir, error code = "+str(error))

	config_path = snippets_dir.plus_file("config.cfg")


func on_ui_rect_changed():
	yield(ui.get_tree(), "idle_frame")
	preview_panel.rect_global_position.y = ui.rect_global_position.y
	preview_panel.rect_global_position.x = ui.rect_global_position.x+ui.rect_size.x


func add_preview():
	var current_script = script_editor.get_current_script()
	if not  current_script is GDScript: return


	var textedit: = Utils.get_current_text_ed(script_editor)
	if not textedit: return

	snippet_preview = textedit.duplicate()
	snippet_preview = snippet_preview as TextEdit
#	snippet_preview.rect_min_size = Vector2(400, 300)

	
#	snippet_preview.rect_size  = Vector2(300, 200)
#	snippet_preview.modulate.a = 0.8
	snippet_preview.readonly  =true
	snippet_preview.breakpoint_gutter = false
	snippet_preview.fold_gutter = false
	snippet_preview.show_line_numbers = false
	snippet_preview.minimap_draw = false
#	snippet_preview.visible = false
	snippet_preview.name = "Preview"
#	snippet_preview.set("read_only", preload("ui/new_styleboxempty.tres"))

#	snippet_preview.set("background_color", Color.red)

	snippet_preview.set("custom_styles/normal", preload("res://addons/snippets/ui/snippets.tres"))
	snippet_preview.set("custom_styles/focus", preload("res://addons/snippets/ui/snippets.tres"))
	snippet_preview.set("custom_styles/read_only", preload("res://addons/snippets/ui/snippets.tres"))

	snippet_preview.rect_size = Vector2(400,300)

	snippet_preview.connect("gui_input", self, "on_preview_gui")

	code_highlight.init(plugin)
	code_highlight.set_missing_highlight(snippet_preview)

	snippet_preview.set("custom_colors/font_color_readonly", preview_font_color)

	preview_panel.rect_size = snippet_preview.rect_size
	preview_panel.add_child(snippet_preview)

# position for completion controls etc
func get_caret_pos()->Vector2:

	var pos: = Vector2.ZERO

	var tab_container:TabContainer =Utils.get_script_tab_container(script_editor)
	var script_text_editor = tab_container.get_current_tab_control()
	var menu:PopupMenu = Utils.find_child_by_type(script_text_editor, PopupMenu)

	var text_edit = Utils.get_current_text_ed(script_editor)
	var sel:=[]
	if text_edit.is_selection_active():
		sel.push_back(text_edit.get_selection_from_line())
		sel.push_back(text_edit.get_selection_from_column())
		sel.push_back(text_edit.get_selection_to_line())
		sel.push_back(text_edit.get_selection_to_column())
		text_edit.deselect()

	var caret_col = text_edit.cursor_get_column()
	var caret_line = text_edit.cursor_get_line()
	

	var event = create_event()


	if menu.visible:
#		return menu.rect_position
		pos = menu.rect_position

	else:
		script_text_editor._text_edit_gui_input(event)
		menu.hide()
		pos = menu.rect_position

#		yield(get_tree(),"idle_frame")

	text_edit.cursor_set_column(caret_col)
	text_edit.cursor_set_line(caret_line)

	# restore selection
	if sel:
		text_edit.select(sel[0], sel[1], sel[2], sel[3])

	return pos


func create_event()->InputEventKey:
	var event = InputEventKey.new()
	event.scancode = KEY_MENU
#	event.pressed = true
#	event.pressed = false
	return event

func _on_plugin_input(event:InputEvent):
	if event is InputEventKey:
		if Input.is_key_pressed(KEY_F12):

			var pos = get_caret_pos()
			ui.rect_global_position = pos

			ui.visible = true
#			var tree = ui.get_node("ItemList")
			var tree = ui.find_node("ItemList")
			tree.grab_focus()
			tree.grab_click_focus()

			preview_panel.rect_global_position = ui.rect_global_position+ui.rect_size*Vector2(1, 0)

		elif Input.is_action_just_pressed("ui_cancel"):
			if ui.visible:
				ui.visible = false
				var textedit: = Utils.get_current_text_ed(script_editor)
				if not textedit: return
				textedit.grab_focus()

			if snippet_preview and snippet_preview.get_parent().visible:
				snippet_preview.get_parent().hide()
			

func on_preview_gui(event:InputEvent):
#	if event is InputEventKey and Input.is_key_pressed(KEY_ESCAPE):
	if event is InputEventKey and Input.is_action_just_pressed("ui_cancel"):
		if snippet_preview and snippet_preview.visible:
			snippet_preview.get_parent().hide()
			snippet_preview.accept_event()


func _on_plugin_exit():
#	return
#	snippet_preview.get_parent().hide()
	if snippet_preview:
		snippet_preview.queue_free()

#	ui.queue_free()
	ui.free()

func get_items_from_config():
	var error = config.load(config_path)
	if error:
		if error ==  ERR_FILE_NOT_FOUND:
			config = create_new_items_config()
			return {}

	if not config.has_section("items"): return {}
	var items_ = {}
	for key in config.get_section_keys("items"):
		items_[key] = config.get_value("items", key)
	return items_


func create_new_items_config()->ConfigFile:
	var config = ConfigFile.new()
#	config.set_value("items", )
	config.save(config_path)
	return config

#from items property
func update_config():
	for key in items:
		config.set_value("items", key, items[key])
	for key in config.get_section_keys("items"):
		if not key in items:
			config.erase_section_key("items", key)



func save_items(update_config: = true):
	if update_config:
		update_config()

	config.save(config_path)

func add_item(id:String, content:String):
	items[id] = content


#config update
func remove_item(id:String):
	items.erase(id)
#	config.era

func get_script_editor_selected_text()->String:
	var textedit: = Utils.get_current_text_ed(script_editor)
	return textedit.get_selection_text()


var can_insert = true

#note: if called from ItemList  etc, that control should ignore focus
func add_text_at_caret(text:String):
	
	if not can_insert: return

	var textedit: = Utils.get_current_text_ed(script_editor)

	if not textedit: return

	#try different:
	OS.clipboard = text
	textedit.menu_option(textedit.MENU_PASTE)

#	textedit.set_block_signals(true)
#
#	textedit.insert_text_at_cursor(text)
#
#	yield(plugin.get_tree(), "idle_frame")
#	yield(plugin.get_tree(), "idle_frame")
#
#	textedit.set_block_signals(false)

#	yield(plugin.get_tree(), "idle_frame")
	yield(plugin.get_tree(), "idle_frame")


	textedit.grab_focus()
#	textedit.grab_click_focus()

	can_insert = true
