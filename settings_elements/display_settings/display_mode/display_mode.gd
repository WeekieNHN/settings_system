extends OptionElement

@export var resolution_setting_reference: OptionElement = null

# Called when the node enters the scene tree for the first time.
func _init() -> void:
	OPTION_LIST_ = SettingsManager.video_settings.DISPLAY_MODE_LIST_

func init_element() -> void:
	super.init_element()
	call_deferred("check_resolution")

func check_resolution() -> void:
	if resolution_setting_reference == null: return
	# Enabled/disable resolution
	resolution_setting_reference.option_reference.set_disabled(currentValue == "Fullscreen")

func option_selected(index: int) -> void:
	super.option_selected(index)
	# Check if the resolution element should be disabled
	check_resolution()
