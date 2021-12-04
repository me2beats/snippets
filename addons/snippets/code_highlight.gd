tool
extends Resource




var comment_color:Color
var keyword_color:Color
var string_color:Color
var base_type_color:Color
var engine_type_color:Color

var function_definition_color:Color

const keywords = [
	'if',
	'elif',
	'else',
	'for',
	'while',
	'match',
	'break',
	'continue',
	'pass',
	'return',
	'class',
	'class_name',
	'extends',
	'is',
	'as',
	'self',
	'tool',
	'signal',
	'func',
	'static',
	'const',
	'enum',
	'var',
	'export',
	'setget',
	'breakpoint',
	'preload',
	'yield',
	'assert',
	'remote',
	'master',
	'puppet',
	'remotesync',
	'mastersync',
	'puppetsync',
	'PI',
	'TAU',
	'INF',
	'NAN',
]

const red_base_types = [
	'bool',
	'int',
	'float',
	'void' #?
]

const gdscript_functions = [
	'Color8',
	'ColorN',
	'abs',
	'acos',
	'asin',
	'assert',
	'atan',
	'atan2',
	'bytes2var',
	'cartesian2polar',
	'ceil',
	'char',
	'clamp',
	'convert',
	'cos',
	'cosh',
	'db2linear',
	'decimals',
	'dectime',
	'deg2rad',
	'dict2inst',
	'ease',
	'exp',
	'floor',
	'fmod',
	'fposmod',
	'funcref',
	'get_stack',
	'hash',
	'inst2dict',
	'instance_from_id',
	'inverse_lerp',
	'is_equal_approx',
	'is_inf',
	'is_instance_valid',
	'is_nan',
	'is_zero_approx',
	'len',
	'lerp',
	'lerp_angle',
	'linear2db',
	'load',
	'log',
	'max',
	'min',
	'move_toward',
	'nearest_po2',
	'ord',
	'parse_json',
	'polar2cartesian',
	'posmod',
	'pow',
	'preload',
	'print',
	'print_debug',
	'print_stack',
	'printerr',
	'printraw',
	'prints',
	'printt',
	'push_error',
	'push_warning',
	'rad2deg',
	'rand_range',
	'rand_seed',
	'randf',
	'randi',
	'randomize',
	'range',
	'range_lerp',
	'round',
	'seed',
	'sign',
	'sin',
	'sinh',
	'smoothstep',
	'sqrt',
	'step_decimals',
	'stepify',
	'str',
	'str2var',
	'tan',
	'tanh',
	'to_json',
	'type_exists',
	'typeof',
	'validate_json',
	'var2bytes',
	'var2str',
	'weakref',
	'wrapf',
	'wrapi',
	'yield',
]

const base_types = [
	
	'Color',
	'Vector2',
	'Vector3',
	'String',
	'Rect2',
	'Transform2D',
	'Plane',
	'Quat',
	'AABB',
	'Basis',
	'Transform',
	'NodePath',
	'RID',
	'Object',
	'Dictionary',
	'Array',
	'PoolByteArray',
	'PoolIntArray',
	'PoolRealArray',
	'PoolStringArray',
	'PoolVector2Array',
	'PoolVector3Array',
	'PoolColorArray',
	'PoolIntArray'
]

const operators = [
	'in',
	'not',
	'and',
	'or'
]


func set_missing_highlight(text_edit:TextEdit):
	# test syntax coloring
	
#		b.add_color_region('func', '(', function_definition_color, true) # doesn't work (?)

	for cls in ClassDB.get_class_list():
		text_edit.add_keyword_color(cls, engine_type_color)
		
		
	for val in keywords:
		text_edit.add_keyword_color(val, keyword_color)

	for val in operators:
		text_edit.add_keyword_color(val, keyword_color)

	for val in red_base_types:
		text_edit.add_keyword_color(val, keyword_color)

	for val in base_types:
		text_edit.add_keyword_color(val, base_type_color)

	for val in gdscript_functions:
		text_edit.add_keyword_color(val, keyword_color)

	text_edit.add_color_region('#', '\n', comment_color, true)
	text_edit.add_color_region('"', '"', string_color, false)
	text_edit.add_color_region("'", "'", string_color, false)


# run this before calling set_missing_highlight()
func init(plugin:EditorPlugin):
	var ed_settings = plugin.get_editor_interface().get_editor_settings()	
	comment_color = ed_settings.get_setting('text_editor/highlighting/comment_color')
	keyword_color = ed_settings.get_setting('text_editor/highlighting/keyword_color')
	base_type_color = ed_settings.get('text_editor/highlighting/base_type_color')
	engine_type_color = ed_settings.get('text_editor/highlighting/engine_type_color')
	string_color = ed_settings.get_setting('text_editor/highlighting/string_color')
