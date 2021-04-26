extends Platform

class_name StaticPlatform

signal body_entered(body, this, platform);
signal player_damaged(body, this);

export(bool) var thorn_visible = false;
var player_entered: bool = false;
# warning-ignore:unused_class_variable
var level_has_growth: bool = false;

func _physics_process(_delta: float) -> void:
  $TileMap.modulate = GlobalVariables.COLOR_PLATFORM;
  $CommonPlatform.thorn_visible = thorn_visible;

func _on_Platform_body_entered(body, platform):
  if (body is Player and not player_entered):
    player_entered = true;

  emit_signal('body_entered', body, self, platform);

func _on_Platform_thorn_visibility(body, is_visible):
  if (is_visible and body is Player):
    emit_signal('player_damaged', body, self)
