extends CanvasLayer

@onready var c_label: Label = $MarginContainer/VBoxContainer/CLabel
@onready var j_label: Label = $MarginContainer/VBoxContainer/JLabel
@onready var q_m_label: Label= $MarginContainer/VBoxContainer/QMLabel

func _process(delta: float) -> void:
	c_label.text = "CoyoteTimer: %.2f" % GameManager.get_coyote()
	j_label.text = "JumpBufferTimer: %.2f" % GameManager.get_jump_buffer()
	
	if GameManager.get_queued_missed() == true:
		q_m_label.label_settings.font_color = Color.BLUE
		q_m_label.label_settings.outline_color = Color.WHITE
		q_m_label.text = "Queued"
	else:
		q_m_label.label_settings.font_color = Color.RED
		q_m_label.label_settings.outline_color = Color.BLACK
		q_m_label.text = "Missed"
