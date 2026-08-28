class_name OptionElement extends SettingsElement

## Default value for the element.
## Value has to exist in OPTION_LIST_ otherwise the first option will be used.
@export var DEFAULT_VALUE: String
## List of options related to the settings element
var OPTION_LIST_
## Index of the currently selected item
var selectedIndex: int

## Element node references
@onready var option_reference: OptionButton = $OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	OPTION_LIST_.make_read_only()
	# Populate with options list
	populate_options()
	# Load letting
	load_setting()
	# Connect selection sigal
	option_reference.item_selected.connect(option_selected)

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
	# Save current value
	currentValue = option_reference.get_item_text(0)

func option_selected(index: int) -> void:
	# Update the element's values
	currentValue = option_reference.get_item_text(index)
	selectedIndex = index
