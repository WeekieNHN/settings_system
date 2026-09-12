extends CanvasLayer

@onready var video_settings: VideoSettingsApplier = %VideoSettingsApplier
@onready var audio_settings: AudioSettingsApplier = %AudioSettingsApplier

## SettingsManager autoload
## Set the following video settings in the godot project file.
## Stretch Mode: Viewport
## Stretch Aspect: Disabled

@export var apply_settings_on_load: bool = true

var _settings: Dictionary = {}

## Settings that need to be applied at startup
## key: String - value: Variant
## We will load from the file, and add these to settings if they dont't exist
var _default_settings: Dictionary = {
	# Display Settings
	"Display Mode": "Windowed",
	"Resolution": "1152x648",
	"Master Volume": 0.5,
	"SFX Volume": 1.0,
	"Music Volume": 1.0,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# load settings from file
	# Will return empty dict if it doesnt exist
	_settings = load_dict_from_json()

	# Apply loaded settings
	for key in _settings.keys():
		print("set %s to %s" % [key, _settings[key]])
		apply_setting(key, _settings[key], true)
	for key in _default_settings.keys():
		if !_settings.has(key): 
			print("set %s to %s" % [key, _default_settings[key]])
			apply_setting(key, _default_settings[key], true)

signal setting_applied(id: String, value: Variant)
func apply_setting(id: String, value: Variant, first_load: bool = false) -> void:
	# Add setting if we don't have it
	if _settings.has(id) == null:
		_settings[id] = value
	# If value has changed or first_load
	elif value != get_setting_value(id) or first_load:
		_settings[id] = value
	# Otherwise return
	else: return
	# Emit signal for other nodes to hook into
	setting_applied.emit(id, value)

#region Save/Load

const SETTINGS_PATH := "user://settings.json"

func save_settings_to_file() -> void:
	save_dict_to_json(_settings, SETTINGS_PATH)

func save_dict_to_json(data: Dictionary, path: String = SETTINGS_PATH) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open file for writing: %s (error %s)" % [path, FileAccess.get_open_error()])
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()

func load_dict_from_json(path: String = SETTINGS_PATH) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("Failed to open file for reading: %s (error %s)" % [path, FileAccess.get_open_error()])
		return {}

	var text := file.get_as_text()
	file.close()

	var parsed = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("Save file did not contain a valid dictionary: %s" % path)
		return {}

	return parsed

#endregion

func get_setting_value(id: String) -> Variant:
	# Return setting value
	return _settings[id] if _settings.has(id) else null
