class_name BasicSettingsPanel extends Control

var _elements: Array[SettingsElement]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	for element in _elements: element.apply_setting()
	# Save settings
	SettingsManager.save_settings_to_file()	
