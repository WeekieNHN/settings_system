class_name VideoSettingsApplier extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect to setting signal
	SettingsManager.setting_applied.connect(apply_video_setting)

# Where we apply the video settings, keep defaults saved here
func apply_video_setting(id: String, value: Variant) -> void:
	match id:
		"Resolution": apply_resolution(value as String)
		"Display Mode": apply_display_mode(value as String)

#region Resolution

const RESOLUTION_LIST_ = {
	"3840x2160": Vector2i(3840,2160),
	"2560x1440": Vector2i(2560,1440),
	"1920x1080": Vector2i(1920,1080),
	"1366x768": Vector2i(1366,768),
	"1280x720": Vector2i(1280,720),
	"1440x900": Vector2i(1440,900),
	"1600x900": Vector2i(1600,900),
	"1152x648": Vector2i(1152, 648),
	"1024x600": Vector2i(1024,600),
	"960x540": Vector2i(960, 540),
	"800x600": Vector2i(800,600),
}

func apply_resolution(value: String) -> void:
	# If fullscreen, ignore or borderless, ignore
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN or DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS): return
	
	# Change the window size to the selected resolution
	get_window().set_size(RESOLUTION_LIST_[value])
	get_viewport().set_size(RESOLUTION_LIST_[value])
	get_window().move_to_center()

#endregion

#region Display Mode

const DISPLAY_MODE_LIST_ = {
	"Fullscreen": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
	"Borderless Windowed": DisplayServer.WINDOW_MODE_WINDOWED,
	"Windowed": DisplayServer.WINDOW_MODE_WINDOWED
}

func apply_display_mode(value: String) -> void:
	DisplayServer.window_set_mode(DISPLAY_MODE_LIST_[value])
	if value == "Borderless Windowed":
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_BORDERLESS,
			true
		)
		adjust_resolution()
	else:
		DisplayServer.window_set_flag(
			DisplayServer.WINDOW_FLAG_BORDERLESS,
			false
		)

# Called to scale the resolution to the provided percentage
func adjust_resolution(sizeScale: float = 1.0) -> void:
	# Grab the screensize
	var displaySize: Vector2i = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()) * sizeScale
	# Set window/Viewport, center if needed
	get_window().set_size(displaySize)
	get_viewport().set_size(displaySize)
	get_window().move_to_center()

#endregion
