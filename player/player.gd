"""
코요테 타임이란?
 - 바닥에서 떨어진 직후, 일정 시간 동안 여전히 점프를 허용하는 기능

점프 버퍼란?
 - 점프 버튼 입력을 잠시 저장했다가, 점프 가능한 순간이 되면 자동으로 실행하는 기능
"""

extends CharacterBody2D

##################################################
enum PlayerState {
	IDLE,
	RUN,
	JUMP
}

enum PlayerDirection {
	LEFT,
	RIGHT
}

##################################################
const RUNNING_SPEED: float = 150.0
const JUMP_VELOCITY: float = -300.0

var player_state: PlayerState = PlayerState.IDLE
var player_direction: PlayerDirection = PlayerDirection.RIGHT

@onready var anim_spr_node = $AnimatedSprite2D

##################################################
""" 코요테 타임, 점프 버퍼 타임 상수 """
# 이 수치를 조정하면 조작감을 극대화시킬 수 있음
const COYOTE_TIME: float = 0.1
const JUMP_BUFFER_TIME: float = 0.1

""" 코요테, 점프 버퍼 타이머 변수 """
var coyote_timer: float = 0.0
var jump_buffer_timer: float = 0.0

##################################################
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		player_state = PlayerState.JUMP
	
	""" 코요테 타이머 갱신 """
	# 바닥에 닿는 순간 타이머를 초기화하고, 추락하는 순간부터 타이머가 줄어듦
	if is_on_floor():
		coyote_timer = COYOTE_TIME
	else:
		coyote_timer -= delta
	
	""" 점프 버퍼 타이머 갱신 """
	# 점프 버튼을 누르는 순간 타이머를 초기화하고, 나머지 순간에는 타이머가 줄어듦
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer = JUMP_BUFFER_TIME
	else:
		jump_buffer_timer -= delta
	
	""" 코요테 타임, 점프 버퍼 로직 업데이트 """
	# 점프가 가능한 시점이면서(and), 점프 입력이 있었는가? 
	if coyote_timer > 0.0 and jump_buffer_timer > 0.0:
	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		# 두 변수를 0.0으로 초기화하지 않아도 작동은 잘 되지만
		# 한 번의 입력으로 점프가 여러 번 실행되는 것을 방지하기 위한 안전 장치
		coyote_timer = 0.0
		jump_buffer_timer = 0.0

	var moving_direction: float = Input.get_axis("ui_left", "ui_right")
	if moving_direction:
		velocity.x = moving_direction * RUNNING_SPEED
		if is_on_floor():
			player_state = PlayerState.RUN
		if moving_direction > 0.0:
			player_direction = PlayerDirection.RIGHT
		elif moving_direction < 0.0:
			player_direction = PlayerDirection.LEFT
	else:
		velocity.x = move_toward(velocity.x, 0, RUNNING_SPEED)
		if is_on_floor():
			player_state = PlayerState.IDLE

	set_state(player_state, player_direction)
	move_and_slide()

##################################################
func set_state(state_value: PlayerState, direction_value: PlayerDirection) -> void:
	match state_value:
		PlayerState.IDLE:
			anim_spr_node.play("idle")
		PlayerState.RUN:
			anim_spr_node.play("run")
		PlayerState.JUMP:
			anim_spr_node.play("jump")
	
	match direction_value:
		PlayerDirection.LEFT:
			anim_spr_node.flip_h = true
		PlayerDirection.RIGHT:
			anim_spr_node.flip_h = false
