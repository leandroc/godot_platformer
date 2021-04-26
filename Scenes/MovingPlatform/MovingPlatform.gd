extends Platform

class_name MovingPlatform

signal body_entered(body, this, platform);
signal player_damaged(body, this);

export(bool) var thorn_visible = false;
var player_entered: bool = false;
# warning-ignore:unused_class_variable
var level_has_growth: bool = false;

export(String, "Top", "Right", "Bottom", "Left") var move_direction = "Right"

const PLATFORM_MOVEMENT_DISTANCE_X: float = GlobalVariables.MOVING_PLATFORM_X_DISTANCE;
const PLATFORM_MOVEMENT_DISTANCE_Y: float = GlobalVariables.MOVING_PLATFORM_Y_DISTANCE;
var PLATFORM_IDDLE_DURATION: float = GlobalVariables.MOVING_PLATFORM_IDDLE_DURATION;
var PLATFORM_SPEED: float = GlobalVariables.MOVING_PLATFORM_SPEED;
var follow = Vector2.ZERO;

func _ready() -> void:
  $TileMap.modulate = GlobalVariables.COLOR_PLATFORM;

  follow = new_transform;

  init_tween(new_transform);

func _physics_process(_delta: float) -> void:
  $Platform.thorn_visible = thorn_visible;

  if ($Tween.is_active()):
    self.position = self.position.linear_interpolate(follow, 0.075)
  elif floor(self.position.x) == floor(new_transform.x):
    $Tween.start();

func get_move_to_from_move_direction(local_transform: Vector2) -> Vector2:
  var direction: Vector2 = local_transform;

  if (move_direction == "Top"):
    direction.y = direction.y - PLATFORM_MOVEMENT_DISTANCE_Y

  if (move_direction == "Right"):
    direction.x = direction.x + PLATFORM_MOVEMENT_DISTANCE_X

  if (move_direction == "Bottom"):
    direction.y = direction.y + PLATFORM_MOVEMENT_DISTANCE_Y

  if (move_direction == "Left"):
    direction.x = direction.x - PLATFORM_MOVEMENT_DISTANCE_X

  return direction;

func init_tween(local_transform: Vector2) -> void:
  var move_to: Vector2 = get_move_to_from_move_direction(local_transform);
  var movement_distance: float = PLATFORM_MOVEMENT_DISTANCE_X if ['Right', 'Left'].has(move_direction) else PLATFORM_MOVEMENT_DISTANCE_Y;
  var duration: float = movement_distance / float(PLATFORM_SPEED * GlobalVariables.SPRITE_UNIT);
  var delay = duration + PLATFORM_IDDLE_DURATION * 2;

  $Tween.interpolate_property(self, 'follow', local_transform, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, PLATFORM_IDDLE_DURATION);
  $Tween.interpolate_property(self, 'follow', move_to, local_transform, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay);

func _on_Platform_body_entered(body, platform):
  if (body is Player and not player_entered):
    player_entered = true;

  emit_signal('body_entered', body, self, platform);

func _on_Platform_thorn_visibility(body, is_visible):
  if (is_visible and body is Player):
    emit_signal('player_damaged', body, self);
