extends Node2D

class_name Menu

signal on_press(this)

func _ready() -> void:
  $CanvasLayer/ColorRect.modulate = GlobalVariables.COLOR_BACKGROUND;
  $CanvasLayer/MarginContainer.modulate = GlobalVariables.COLOR_PLAYER;

func _process(_delta: float) -> void:
  if (Input.is_action_just_released('ui_jump')):
    emit_signal('on_press', self);

func _on_Button_pressed() -> void:
 emit_signal('on_press', self);
