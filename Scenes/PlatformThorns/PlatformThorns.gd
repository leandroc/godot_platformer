extends Area2D

signal thorn_visibility(body, is_visible)

export(bool) var is_thorn_visible = false;
var body_entered = null;

func _ready() -> void:
  modulate = GlobalVariables.COLOR_PLATFORM_THORNS;

func show_thorns() -> void:
  is_thorn_visible = true;

func hide_thorns() -> void:
  is_thorn_visible = false;

func _physics_process(_delta: float) -> void:
  $ThornUp.visible = is_thorn_visible;
  $ThornDown.visible = !is_thorn_visible;
  if (body_entered and self.visible):
    emit_signal('thorn_visibility', body_entered, is_thorn_visible);

func _on_Timer_timeout():
  $Delay.start();
  hide_thorns();

func _on_Delay_timeout():
  $Timer.start();
  show_thorns();

func _on_PlatformThorns_body_entered(body):
  body_entered = body;

func _on_PlatformThorns_body_exited(_body):
  body_entered = null;
