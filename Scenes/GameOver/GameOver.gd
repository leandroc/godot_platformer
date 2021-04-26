extends Node2D

class_name GameOver

signal on_restart(this, score)

export(float) var score = 0;

func _ready() ->void:
  $CanvasLayer/ColorRect.modulate = GlobalVariables.COLOR_BACKGROUND;
  $CanvasLayer/Container/VBoxContainer/ButtonBox.modulate = GlobalVariables.COLOR_PLAYER;

func _process(_delta: float) -> void:
  $CanvasLayer/Container/VBoxContainer/ScoreBox/Label.text = str(score);

  if (Input.is_action_just_released('ui_jump')):
    emit_signal('on_restart', self, score)

func _on_Button_pressed() -> void:
  emit_signal('on_restart', self, score)
