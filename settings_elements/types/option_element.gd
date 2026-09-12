class_name OptionElement extends SettingsElement

## Default value for the element.
## Value has to exist in OPTION_LIST_ otherwise the first option will be used.
@export var DEFAULT_VALUE: String
## List of options related to the settings element
var OPTION_LIST_: Dictionary
## Index of the currently selected item
var selectedIndex: int

## Element node references
@onready var option_reference: OptionButton = $OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	OPTION_LIST_.make_read_only()
	# Connect selection sigal
	option_reference.item_selected.connect(option_selected)

func load_setting() -> void:
	# Parent class logic
	super.load_setting()
	# Load setting if it exists, otherwise set to default value
	if SettingsManager.get_setting_value(IDENTIFIER) == null:
		currentValue = DEFAULT_VALUE
	else: currentValue = SettingsManager.get_setting_value(IDENTIFIER)

func init_element() -> void:
	# Run parent class logic
	super.init_element()
	# Populate options before we select one
	populate_options()
	# Get index of current resolution's option
	var option_index: int = OPTION_LIST_.keys().find(currentValue)
	# Select that option
	selectedIndex = option_index
	option_reference.select(option_index)
	option_reference.selected = option_index

func populate_options() -> void:
	# Make sure we have options
	if !OPTION_LIST_: return
	# Clear optioons from element
	option_reference.clear()
	# Add the options from the received option list of the element
	var index: int = 0
	for option in OPTION_LIST_:
		# Add item
		option_reference.add_item(option, index)
		# Increase index
		index += 1

func option_selected(index: int) -> void:
	# Update the element's values
	currentValue = option_reference.get_item_text(index)
	selectedIndex = index
	# If apply on change, apply the setting now
	if apply_on_change: apply_setting()
