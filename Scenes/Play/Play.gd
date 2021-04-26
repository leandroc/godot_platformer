extends Node2D

class_name Play

signal player_is_dead(this, player, score)

const PLATFORM_SCENES = [
  preload('res://Scenes/StaticPlatform/StaticPlatform.tscn'),
  preload('res://Scenes/MovingPlatform/MovingPlatform.tscn'),
 ];

var random_number_generator = RandomNumberGenerator.new();
var last_platform_id: int = 4;

func _process(_delta: float) -> void:
  random_number_generator.randomize();
  _loop_through_platform();

func _loop_through_platform() -> void:
  var platform_list = self.get_tree().get_nodes_in_group('Platform');

  if (platform_list.size() > 0):
    for platform in platform_list:
      if (platform.player_entered and not platform.level_has_growth):
        platform.level_has_growth = true;
        $Level.level_height = $Level.level_height + GlobalVariables.LEVEL_HEIGHT_GROWTH;
        _create_platform(platform);
        _remove_platform(platform, platform_list);

func _create_platform(_platform: Platform) -> void:
  var index: int = random_number_generator.randi_range(0, 1);
  var show_thorn: bool = bool(random_number_generator.randi_range(0, 1));
  var scene_to_add = PLATFORM_SCENES[index].instance();
  var new_last_id: int = last_platform_id + 1;
  scene_to_add.position_x = 'Right' if (_platform.position_x == 'Left') else 'Left'
  scene_to_add.position.y = _platform.position.y - GlobalVariables.PLATFORM_DISTANCE_TO_NEW;
  scene_to_add.name = scene_to_add.name + '_' + str(new_last_id);

  var player_position_score: float = abs(round($Level/Player.position.y / 8));

  if (show_thorn and player_position_score > GlobalVariables.MIN_POINTS_TO_SHOW_THORNS):
    scene_to_add.thorn_visible = show_thorn;
    scene_to_add.connect('player_damaged', self, '_on_thorn_body_entered')

  if (scene_to_add is MovingPlatform):
    scene_to_add.move_direction = 'Left' if (_platform.position_x == 'Left') else 'Right';

  last_platform_id = new_last_id;
  add_child(scene_to_add);

func _remove_platform(_platform: Platform, _platform_list: Array) -> void:
  var platform_to_remove_position_y: float = _platform.position.y + GlobalVariables.PLATFORM_DISTANCE_TO_NEW;

  for platform in _platform_list:
    if (platform.position.y == platform_to_remove_position_y):
      platform.queue_free();

func _on_Level_player_is_dead(player, height) -> void:
  emit_signal('player_is_dead', self, player, height);

func _on_thorn_body_entered(body, is_visible) -> void:
  print('hi player')
  if (is_visible and body is Player):
    emit_signal('player_is_dead', self, body, abs(round(body.position.y / 8)));
