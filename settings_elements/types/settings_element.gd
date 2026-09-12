class_name SettingsElement extends Control 

## Is this element enabled?
## If True, we'll listen for "apply signal"
@export var enabled: bool = true

## Identifier for the element.
## This value is used as the key in the settings data.
@export var IDENTIFIER: String = "Element"

@export var apply_on_change: bool = false

## Current value of the element.
var currentValue

func _ready() -> void: 
	load_setting()
	init_element()

func apply_setting() -> void:
	SettingsManager.apply_setting(IDENTIFIER, currentValue)

func load_setting() -> void: pass

func init_element() -> void: pass
