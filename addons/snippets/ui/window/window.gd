tool
extends Control

var resize_half_size: = 5

export var Api:Resource

export (NodePath) var head_path
onready var head = get_node(head_path)
export var head_visible: = true setget setter_head_visible

onready var panel = $Panel

signal close_pressed

# head released after its pressed by mouse
signal head_released




export var make_transparent_on_mouse_exit = false
var is_mouse_in_rect: = false

enum Edges {
	LEFT_UP =1,
	LEFT_BOTTOM,
	LEFT,
	RIGHT_UP,
	RIGHT_BOTTOM,
	RIGHT,
	UP,
	DOWN
}

var edge_pressed: = 0
onready var recent_rect:=get_rect()
onready var recent_m_pos: = get_global_mouse_position()

func setter_head_visible(val):
	head_visible = val
	head.get_parent().visible = val

func _ready():

	init_components()

	set_global_position(Api.ui_window_rect.position)
	var rect_sz = Api.ui_window_rect.size
	if rect_sz:
		rect_size = Api.ui_window_rect.size


func init_components():
	for c in components:
		c = c as Resource
		if c.has_method('init'):
			c.init(self)

export (Array, Resource) var components


# better name needed
func emit_components(event:InputEventMouseButton):
	for component in components:
		component = component as Resource
		if component.has_method("_input"):
			component.call("_input", event)


func _input(event):
	if not visible: return
	
	if event is InputEventMouseButton:
		emit_components(event)
		
#		if !event.pressed:
#			emit_signal('head_released')


	if event is InputEventKey and Input.is_key_pressed(KEY_F12):
		show()
		return
	
	if event is InputEventMouseButton:
		if !event.is_pressed():
			edge_pressed = 0
			mouse_default_cursor_shape = 0
			
			# save/store rect pos
			Api.ui_window_rect = get_global_rect()
			
			return

		recent_rect = get_rect()
		recent_m_pos = get_global_mouse_position()

		var rect: = get_global_rect()
		var max_rect: = rect.grow(resize_half_size)
		var min_rect: = rect.grow(-resize_half_size)
		var pos:Vector2 = event.global_position

		if not max_rect.has_point(pos):

			return


		if min_rect.has_point(pos): return

		if pos.x<min_rect.position.x:
			if pos.y<min_rect.position.y:
				edge_pressed = Edges.LEFT_UP
			elif pos.y>min_rect.end.y:
				edge_pressed = Edges.LEFT_BOTTOM
			else:
				edge_pressed = Edges.LEFT

		elif pos.x>min_rect.end.x:
			if pos.y<min_rect.position.y:
				edge_pressed = Edges.RIGHT_UP
			elif pos.y>min_rect.end.y:
				edge_pressed = Edges.RIGHT_BOTTOM
			else:
				edge_pressed = Edges.RIGHT

		elif pos.y< min_rect.position.y:
			edge_pressed = Edges.UP
		elif pos.y> min_rect.end.y:
			edge_pressed = Edges.DOWN

	else:
		if event is InputEventMouseMotion:

			if make_transparent_on_mouse_exit:
				var rect: = get_global_rect()
				var max_rect: = rect.grow(resize_half_size)
				
				var pos:Vector2 = event.global_position

				if not max_rect.has_point(pos):
					if is_mouse_in_rect:
						is_mouse_in_rect = false
		#				modulate.a = 0.5
						$Tween.interpolate_property(self, "modulate:a", modulate.a, 0.5, 0.4, Tween.TRANS_QUAD)
						$Tween.start()

				elif not is_mouse_in_rect:
					is_mouse_in_rect = true
		#			modulate.a = 1
					$Tween.interpolate_property(self, "modulate:a", modulate.a, 1, 0.4, Tween.TRANS_QUAD)
					$Tween.start()

			
			
			if not edge_pressed:return

			match edge_pressed:
				Edges.LEFT:
					rect_position.x = recent_rect.position.x+get_global_mouse_position().x-recent_m_pos.x
					rect_size.x = recent_rect.size.x-(get_global_mouse_position().x-recent_m_pos.x)
				Edges.RIGHT:
					rect_size.x = recent_rect.size.x+(get_global_mouse_position().x-recent_m_pos.x)

				Edges.UP:
					rect_position.y = recent_rect.position.y+get_global_mouse_position().y-recent_m_pos.y
					rect_size.y = recent_rect.size.y-(get_global_mouse_position().y-recent_m_pos.y)
					
				Edges.DOWN:
					rect_size.y = recent_rect.size.y+(get_global_mouse_position().y-recent_m_pos.y)

				Edges.RIGHT_BOTTOM:
					rect_size = recent_rect.size+(get_global_mouse_position()-recent_m_pos)

				Edges.LEFT_UP:
					rect_position = recent_rect.position+get_global_mouse_position()-recent_m_pos
					rect_size = recent_rect.size-(get_global_mouse_position()-recent_m_pos)

				Edges.RIGHT_UP:
					rect_position.y = recent_rect.position.y+get_global_mouse_position().y-recent_m_pos.y
					rect_size.y = recent_rect.size.y-(get_global_mouse_position().y-recent_m_pos.y)
					rect_size.x = recent_rect.size.x+(get_global_mouse_position().x-recent_m_pos.x)

				Edges.LEFT_BOTTOM:
					rect_position.x = recent_rect.position.x+get_global_mouse_position().x-recent_m_pos.x
					rect_size.y = recent_rect.size.y+(get_global_mouse_position().y-recent_m_pos.y)
					rect_size.x = recent_rect.size.x-(get_global_mouse_position().x-recent_m_pos.x)
			
			var panel_min_size = panel.get_minimum_size()
			rect_size.x = clamp(rect_size.x, panel_min_size.x, 10000)
			rect_size.y = clamp(rect_size.y, panel_min_size.y, 10000)

			accept_event()



func _on_Close_pressed():
	emit_signal("close_pressed")
