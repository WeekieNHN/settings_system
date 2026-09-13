class_name TabbedSettingsPanel extends Control

signal back_pressed ()

# Main Panel
@onready var apply_button: Button = %ApplyButton
@onready var back_button: Button = %BackButton
# Unsaved Changes Panel
@onready var discard_changes_panel: Panel = %DiscardChangesPanel
@onready var discard_button: Button = %DiscardButton
@onready var keep_editing_button: Button = %KeepEditingButton

var _elements: Array[SettingsElement]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect button signals
	apply_button.pressed.connect(apply_settings) # Apply all the settings
	back_button.pressed.connect(on_back_button) # Conditional behaviour
	keep_editing_button.pressed.connect(discard_changes_panel.hide) # Hide the panel and go back to editing
	discard_button.pressed.connect(back_pressed.emit) # Big signal
	# Find all SettingsElements and setup 
	find_settings_elements()
	# Hide discard_changes_panel
	discard_changes_panel.visible = false

func on_back_button() -> void:
	# Check if we have unsaved changes
	var unsaved_flag: bool = false
	for element in _elements: 
		if element.currentValue != SettingsManager.get_setting_value(element.IDENTIFIER):
			unsaved_flag = true
			break
	discard_changes_panel.visible = unsaved_flag
	# Otherwise close panel
	if !unsaved_flag: back_pressed.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func find_settings_elements() -> void:
	# Find all elements
	for element in find_children("*", "SettingsElement", true, false):
		_elements.append(element) # Save Reference
		# element.load_setting()

func apply_settings () -> void:
	# Apply settings
	for element in _elements: element.apply_setting()
	# Save settings
	SettingsManager.save_settings_to_file()	
