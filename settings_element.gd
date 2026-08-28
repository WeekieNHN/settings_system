class_name SettingsElement extends Control 

## Is this element enabled?
## If Tryue, we'll listen for "apply signal"
@export var enabled: bool = true

## Identifier for the element.
## This value is used as the key in the settings data.
@export var IDENTIFIER: String = "Element"

## Current value of the element.
var currentValue

func _ready() -> void: pass

func on_apply() -> void: pass

func load_setting() -> void: pass
