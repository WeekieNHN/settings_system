class_name SliderElement extends SettingsElement

# Default values for the element
@export var MIN_VALUE: float = 0
@export var MAX_VALUE: float = 1
@export var STEP_VALUE: float = 0.1
@export var DEFAULT_VALUE: float = 1

## If true, displays 0 to 100 instead of 0 to 1 in the settings,
## but the true value remains the same.
@export var DISPLAY_PERCENT_VALUE: bool = false

## An extra suffix for the value (optional).
@export var VALUE_SUFFIX: String = ""

## Reference to the slider of the element.
@export var slider_reference: HSlider
## Reference to the SpinBox or Label of the element.
@export var value_box_reference: Control

func load_setting() -> void:
	# Parent class logic
	super.load_setting()
	# Load setting if it exists, otherwise set to default value
	if SettingsManager.get_setting_value(IDENTIFIER) == null:
		currentValue = DEFAULT_VALUE
	else: currentValue = SettingsManager.get_setting_value(IDENTIFIER)
	
	# Set slider/spinbox value
	slider_reference.set_value(currentValue)
	if value_box_reference is SpinBox:
		value_box_reference.set_value(currentValue)
	else:
		value_box_reference.set_text(str(currentValue) + VALUE_SUFFIX)

## Overwrite for SettingsElement.
func _ready() -> void:
	super._ready()
	# Initialize the UI elements
	init_slider(100 if DISPLAY_PERCENT_VALUE else 1)

## Called to initialize the slider element.
func init_slider(FACTOR: float) -> void:
	# Apply the min/max/step/current value of the SliderRef
	slider_reference.set_min(MIN_VALUE * FACTOR)
	slider_reference.set_max(MAX_VALUE * FACTOR)
	slider_reference.set_step(STEP_VALUE * FACTOR)
	slider_reference.set_value(currentValue * FACTOR)
	
	# Connect the value changed signal for the SliderRef
	if not slider_reference.is_connected("value_changed", slider_value_changed):
		slider_reference.connect("value_changed", slider_value_changed.bind(FACTOR))
	
	# Check if the value box is a spin box or a label
	if value_box_reference is SpinBox:
		# Apply the min/max/step/current value of the spin box
		value_box_reference.set_min(MIN_VALUE * FACTOR)
		value_box_reference.set_max(MAX_VALUE * FACTOR)
		value_box_reference.set_step(STEP_VALUE * FACTOR)
		value_box_reference.set_value(currentValue * FACTOR)
		
		# Add caret blink to spin box
		value_box_reference.get_line_edit().set_caret_blink_enabled(true)
		
		value_box_reference.set_suffix(VALUE_SUFFIX)
		
		# Connect the value changed signal of the spin box
		if not value_box_reference.is_connected("value_changed", value_box_value_changed):
			value_box_reference.connect("value_changed", value_box_value_changed)
	else:
		# Set the text as the current value
		value_box_reference.set_text(str(currentValue) + VALUE_SUFFIX)

## Gets the valid values from the element to be used for validating data.
func get_valid_values() -> Dictionary:
	# Check if value is out of bounds
	if DEFAULT_VALUE > MAX_VALUE or DEFAULT_VALUE < MIN_VALUE:
		push_warning("Invalid default value for element '" + IDENTIFIER + "'.")
		DEFAULT_VALUE = clampf(DEFAULT_VALUE, MIN_VALUE, MAX_VALUE)
	
	return {
		"defaultValue": DEFAULT_VALUE,
		"minValue": MIN_VALUE,
		"maxValue": MAX_VALUE,
	}

## Used to update values of the section cache the element is under.
func value_changed(value: float) -> void:
	# Save the current value
	currentValue = value

func slider_value_changed(value: float, FACTOR: float) -> void:
	if value_box_reference is SpinBox:
		value_box_reference.set_value(value)
	else:
		value_box_reference.set_text(str(value) + VALUE_SUFFIX)
	value_changed(value / FACTOR)
	# If apply on change, apply the setting now
	if apply_on_change: apply_setting()

func value_box_value_changed(value: float) -> void:
	slider_reference.set_value(value)
	# If apply on change, apply the setting now
	if apply_on_change: apply_setting()
