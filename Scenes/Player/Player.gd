extends KinematicBody2D

class_name Player

const SPEED: int = GlobalVariables.PLAYER_SPEED;
const MAX_JUMP_HEIGHT: float = GlobalVariables.PLAYER_MAX_JUMP_HEIGHT
const MIN_JUMP_HEIGHT: float = GlobalVariables.PLAYER_MIN_JUMP_HEIGHT;
const JUMP_DURATION: float = GlobalVariables.PLAYER_JUMP_DURATION;
const COYOTE_TIMER_DURATION: float = GlobalVariables.PLAYER_COYOTE_TIMER_DURATION;

var _gravity: float = GlobalVariables.GRAVITY;
var velocity: Vector2 = Vector2.ZERO;
var is_jumping: bool = false;
var max_jump_velocity: float = 0;
var min_jump_velocity: float = 0;

func _ready() -> void:
  $AnimatedSprite.modulate = GlobalVariables.COLOR_PLAYER;

  _gravity = 2 * MAX_JUMP_HEIGHT / pow(JUMP_DURATION, 2);
  max_jump_velocity = -sqrt(2 * _gravity * MAX_JUMP_HEIGHT);
  min_jump_velocity = -sqrt(2 * _gravity * MIN_JUMP_HEIGHT);

func _physics_process(_delta: float) -> void:
  _get_input();
  _get_animations();

  velocity.y = velocity.y + (_gravity * _delta );

  if (is_jumping && velocity.y >= 0):
    is_jumping = false;

  if (is_on_floor() and not is_jumping):
    velocity.y = 0

  var was_on_floor = is_on_floor();

  var stop_on_slope = get_floor_velocity().x == 0;
  var snap: Vector2 = Vector2.DOWN * (floor(GlobalVariables.SPRITE_UNIT) / 2) if not is_jumping else Vector2.ZERO;
  velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP, stop_on_slope);

  if (was_on_floor and !is_on_floor() and !is_jumping):
    $CoyoteTimer.start(COYOTE_TIMER_DURATION);

func _get_input() -> void:
  var x_direction: int = -int(Input.is_action_pressed('ui_left')) + int(Input.is_action_pressed('ui_right'));
  velocity.x = lerp(velocity.x, SPEED * x_direction, 0.2);

  $AnimatedSprite.flip_h = bool(x_direction);

func _input(_event: InputEvent) -> void:
  if _event.is_action_pressed('ui_jump'):
    if (is_on_floor() or !$CoyoteTimer.is_stopped()):
      $CoyoteTimer.stop();
      velocity.y = max_jump_velocity;
      is_jumping = true;

  if _event.is_action_released('ui_jump'):
    if velocity.y < min_jump_velocity:
      velocity.y = min_jump_velocity

func _get_animations() -> void:
  if (velocity.x > 0):
    $AnimatedSprite.flip_h = false;
    $AnimatedSprite.play('run');
  elif (velocity.x < 0):
    $AnimatedSprite.flip_h = true;
    $AnimatedSprite.play('run');

  if (velocity.y > 0):
    $AnimatedSprite.play('fall');
  elif (velocity.y < 0):
    $AnimatedSprite.play('jump');

  $AnimatedSprite.play('run');
