class_name AudioSettingsApplier extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to setting signal
	SettingsManager.setting_applied.connect(apply_audio_setting)
	# Setup our buses
	_ensure_bus_exists("SoundEffects")
	_ensure_bus_exists("Music")

# Where we apply the video settings, keep defaults saved here
func apply_audio_setting(id: String, value: Variant) -> void:
	# We only care about audio settings
	match id:
		"Master Volume": set_bus_volume("Master", value as float)
		"SFX Volume": set_bus_volume("SoundEffects", value as float)
		"Music Volume": set_bus_volume("Music", value as float)

#region Buses

func _ensure_bus_exists(bus_name: String, send_to: String = "Master") -> void:
	if AudioServer.get_bus_index(bus_name) == -1:
		AudioServer.add_bus()
		var idx := AudioServer.bus_count - 1
		AudioServer.set_bus_name(idx, bus_name)
		AudioServer.set_bus_send(idx, send_to)

func set_bus_volume(bus_id: String, value: float) -> void:
	# Get the index of the audio bus
	var bus_index: int = AudioServer.get_bus_index(bus_id)
	# Set the volume of the audio bus
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

#endregion
