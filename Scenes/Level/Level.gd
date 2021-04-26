extends Node2D

class_name Level

signal player_is_dead(player, height)

export(int) var level_height = 320
var max_height_that_player_could_reach: float = 0.0;

func _ready() -> void:
  $HUD/ScoreBox.hide();
  $HUD/Panel.hide();

  $DeadZone/ColorRect.modulate = GlobalVariables.COLOR_DEADZONE;
  $Background/ColorRect.modulate = GlobalVariables.COLOR_BACKGROUND;
  $Floor.modulate = GlobalVariables.COLOR_PLATFORM;

  if !$DeadZoneTimer.is_stopped():
    $DeadZoneTimer.stop();

func _process(_delta: float) -> void:
  _update_camera();
  _update_deadzone(_delta);
  _update_player_max_height();
  _update_walls();

func _update_camera() -> void:
  var screen_size: Vector2 = self.get_viewport_rect().size;

  var bottom_half_screen_height = screen_size.y / 2;
  var top = (level_height - screen_size.y) * -1;
  var top_half_screen_height = bottom_half_screen_height + top;

  # max camera position.y
  var y = max(min($Player.position.y, bottom_half_screen_height), top_half_screen_height);

  $Camera2D.position.y = y;
  $Camera2D.position.x = screen_size.x / 2; # middle of the screen.x

func _update_deadzone(_delta: float) -> void:
  var DEAD_ZONE_SPEED: int = 15;
  var DEAD_ZONE_SPEED_HIGH: int = DEAD_ZONE_SPEED * 8;
  var MAX_DISTANCE_FROM_PLAYER: int = 160;
  var deadzone_position: Vector2 = $DeadZone.get_global_position();
  var deadzone_distance_from_player: int = deadzone_position.y - $Player.position.y;
  var speed = DEAD_ZONE_SPEED if deadzone_distance_from_player < MAX_DISTANCE_FROM_PLAYER else DEAD_ZONE_SPEED_HIGH;

  deadzone_position.y = deadzone_position.y - speed * _delta;

  if ($Player.position.y <= 0):
    $DeadZone.position = deadzone_position;

func _update_player_max_height() -> void:
  var player_current_height = $Player.position.y;

  if (player_current_height < 0 and player_current_height < max_height_that_player_could_reach):
    max_height_that_player_could_reach = round(player_current_height);
    $HUD/ScoreBox.show();
    $HUD/Panel.show();
    $HUD/ScoreBox/HBoxContainer/Score.text = 'x' + str(_get_score());

func _get_score() -> float:
  return abs(round(max_height_that_player_could_reach / 8));

func _update_walls() -> void:
  var player_y: float = $Player.position.y;
  $Walls.position.y = player_y;

func _on_DeadZone_body_entered(body):
  if (body is Player):
    $DeadZoneTimer.start();

func _on_DeadZoneTimer_timeout():
  if ($Player.position.y >= $DeadZone.position.y):
    emit_signal('player_is_dead', $Player, _get_score())
