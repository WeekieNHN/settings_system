extends OptionElement

func _init() -> void:
	# Save list of options
	OPTION_LIST_ = {
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

func load_setting() -> void:
	super()
	# Get index of current resolution's option
	var option_index: int = OPTION_LIST_.keys().find("%sx%s" % [get_window().size.x, get_window().size.y])
	# Select that option
	option_reference.select(option_index)

func on_apply() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		return
	
	if DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS):
		return
	
	# Change the window size to the selected resolution
	get_window().set_size(OPTION_LIST_[currentValue])
	get_viewport().set_size(OPTION_LIST_[currentValue])
	get_window().move_to_center()
