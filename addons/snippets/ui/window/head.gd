tool
extends Button

onready var recent_rect=owner.get_rect()
onready var recent_m_pos: = get_global_mouse_position()

var is_pressed: = false

func _input(event):
	if event is InputEventMouseButton:
#		if !event.is_pressed():
		recent_rect = owner.get_rect()
		recent_m_pos = get_global_mouse_position()

	else:
		if event is InputEventMouseMotion:
			if not pressed: return

			owner.rect_position = recent_rect.position+get_global_mouse_position()-recent_m_pos
