extends CanvasLayer

## SettingsManager autoload
## Set the following video settings in the godot project file.
## Stretch Mode: Viewport
## Stretch Aspect: Disabled

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# config. the video settings
	configure_video_settings()

#region Video Settings


func configure_video_settings() -> void:
	pass
	# Test setting resolution and fullscreen
	## DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	# DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	
	#get_window().set_size(resolutions["2560x1440"])
	#get_viewport().set_size(resolutions["2560x1440"])
	#get_window().move_to_center()

#endregion
