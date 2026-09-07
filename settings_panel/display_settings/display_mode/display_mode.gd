extends OptionElement

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	OPTION_LIST_ = {
		"Fullscreen": DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN,
		"Borderless Windowed": DisplayServer.WINDOW_MODE_WINDOWED,
		"Windowed": DisplayServer.WINDOW_MODE_WINDOWED
	}


func on_apply() -> void:
	print(currentValue)
	DisplayServer.window_set_mode(OPTION_LIST_[currentValue])
	
	if currentValue == "Borderless Windowed":
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

func load_setting() -> void:
	super()
	# Match the current display mode
	match DisplayServer.window_get_mode():
		DisplayServer.WINDOW_MODE_WINDOWED:
			print("Windowed")
			currentValue = "Windowed"
		DisplayServer.WINDOW_MODE_MINIMIZED:
			print("Minimized")
		DisplayServer.WINDOW_MODE_MAXIMIZED:
			print("Maximized")
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			currentValue = "Fullscreen"
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			print("Borderless / Exclusive Fullscreen depending on OS")
		_:
			print("no match")
		
		# Get index of current resolution's option
	var option_index: int = OPTION_LIST_.keys().find(currentValue)
	# Select that option
	option_reference.select(option_index)

# Called to scale the resolution to the provided percentage
func adjust_resolution(sizeScale: float = 1.0) -> void:
	# Grab the screensize
	var displaySize: Vector2i = DisplayServer.screen_get_size(DisplayServer.window_get_current_screen()) * sizeScale
	# Set window/Viewport, center if needed
	get_window().set_size(displaySize)
	get_viewport().set_size(displaySize)
	get_window().move_to_center()
