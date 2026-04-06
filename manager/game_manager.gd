extends Node

##################################################
var coyote: float = 0.0
var jump_buffer: float = 0.0
var queued_missed: bool = false

##################################################
func _process(delta: float) -> void:
	if jump_buffer > 0.0:
		queued_missed = true
	else:
		queued_missed = false

##################################################
func get_coyote() -> float:
	return coyote

##################################################
func set_coyote(coyote_value: float) -> void:
	coyote = coyote_value

##################################################
func get_jump_buffer() -> float:
	return jump_buffer

##################################################
func set_jump_buffer(jump_buffer_value: float) -> void:
	jump_buffer = jump_buffer_value

##################################################
func get_queued_missed() -> bool:
	return queued_missed
