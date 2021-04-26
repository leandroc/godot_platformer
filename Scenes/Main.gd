extends Node2D

class_name Main

const SCENES = [
  preload('res://Scenes/Menu/Menu.tscn'),
  preload('res://Scenes/Play/Play.tscn'),
  preload('res://Scenes/GameOver/GameOver.tscn'),
 ];

var current_max_score: float = 0;
var score: float = 0;

func _ready() -> void:
  _call_menu();

func _on_start(_scene, _score: float = 0) -> void:
  score = _score;
  _call_play(_scene)

func _on_player_dead(_play: Play, _player: Player, _score: float) -> void:
  score = _score;
  current_max_score = _score;
  _call_game_over(_play);

func _call_menu(_scene = null) -> void:
  var menu_scene: Menu = SCENES[0].instance();
  add_child(menu_scene);
  # warning-ignore:return_value_discarded
  menu_scene.connect('on_press', self, '_on_start');

  if _scene:
    _scene.queue_free();

func _call_play(_scene = null) -> void:
  var play_scene: Play = SCENES[1].instance();
  add_child(play_scene);
  # warning-ignore:return_value_discarded
  play_scene.connect('player_is_dead', self, '_on_player_dead');
  # play_scene.current_max_score = current_max_score;

  if _scene:
    _scene.queue_free();

func _call_game_over(_scene = null) -> void:
  var game_over_scene: GameOver = SCENES[2].instance();
  add_child(game_over_scene);
  # warning-ignore:return_value_discarded
  game_over_scene.connect('on_restart', self, '_on_start');
  game_over_scene.score = score;

  if _scene:
    _scene.queue_free();
