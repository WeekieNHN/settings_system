class_name  SettingsPanel extends Control

signal back_pressed ()

@onready var apply_button: Button = %ApplyButton
@onready var back_button: Button = %BackButton

var _elements: Array[SettingsElement]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect back button to big signal
	back_button.pressed.connect(back_pressed.emit)
	apply_button.pressed.connect(apply_settings)
	# Find all SettingsElements and setup 
	find_settings_elements()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func find_settings_elements() -> void:
	# Find all elements
	for element in find_children("*", "SettingsElement", true, false):
		_elements.append(element) # Save Reference
		# element.load_setting()

func apply_settings () -> void:
	# Apply settings
	for element in _elements: element.on_apply()
